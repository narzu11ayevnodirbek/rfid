package uz.tatu.rf_id_test.rfid

import android.content.Context
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

/**
 * Connects [UhfReader] to Dart (`lib/core/rfid/platform_rfid_reader.dart`).
 *
 * Methods (channel `uz.tatu.rfid/reader`):
 * - `initialize` → `true`, or error `UNAVAILABLE` / `INIT_FAILED`
 * - `setPower {dbm}` → whether the module accepted it
 * - `startScanning {readImmediately}` → whether the reader is armed
 * - `stopScanning`, `setKeyEventReporting {enabled}` → `true`
 *
 * Events (channel `uz.tatu.rfid/reader_events`), one map each:
 * - `{type: "tag", epc}`
 * - `{type: "reading", value}`
 * - `{type: "key", code, down}` while key event reporting is on
 *
 * The full contract is in `docs/RFID.md`.
 */
class RfidChannel(context: Context, messenger: BinaryMessenger) :
    MethodChannel.MethodCallHandler,
    EventChannel.StreamHandler,
    UhfReader.Listener {

    private val reader = UhfReader(context, this)
    private val methods = MethodChannel(messenger, METHOD_CHANNEL)
    private val events = EventChannel(messenger, EVENT_CHANNEL)

    private var sink: EventChannel.EventSink? = null
    private var reportsKeyEvents = false

    init {
        methods.setMethodCallHandler(this)
        events.setStreamHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "initialize" -> reader.initialize { outcome ->
                when (outcome) {
                    UhfReader.InitResult.READY -> result.success(true)
                    UhfReader.InitResult.INIT_FAILED ->
                        result.error("INIT_FAILED", "The UHF module did not power on", null)
                    UhfReader.InitResult.UNAVAILABLE ->
                        result.error("UNAVAILABLE", "No supported UHF module on this device", null)
                }
            }

            "setPower" -> {
                val dbm = call.argument<Int>("dbm")
                if (dbm == null) {
                    result.error("BAD_ARGUMENT", "dbm is required", null)
                } else {
                    result.success(reader.setPower(dbm))
                }
            }

            "startScanning" -> {
                val readImmediately = call.argument<Boolean>("readImmediately") ?: true
                result.success(reader.arm(readImmediately))
            }

            "stopScanning" -> {
                reader.disarm()
                result.success(true)
            }

            "setKeyEventReporting" -> {
                reportsKeyEvents = call.argument<Boolean>("enabled") ?: false
                result.success(true)
            }

            else -> result.notImplemented()
        }
    }

    /**
     * Handles a hardware key. Returns `true` when the key was the trigger and
     * the reader is armed, so the activity does not pass it on.
     */
    fun onKey(keyCode: Int, isDown: Boolean, repeatCount: Int): Boolean {
        if (reportsKeyEvents && repeatCount == 0) {
            sink?.success(mapOf("type" to "key", "code" to keyCode, "down" to isDown))
        }
        if (!reader.isArmed || !TriggerKeys.isTrigger(keyCode)) return false
        if (isDown) {
            if (repeatCount == 0) reader.startReading()
        } else {
            reader.stopReading()
        }
        return true
    }

    /** The app went to the background: stop the radio, stay armed. */
    fun pauseReading() = reader.stopReading()

    fun dispose() {
        reader.shutdown()
        methods.setMethodCallHandler(null)
        events.setStreamHandler(null)
        sink = null
    }

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        sink = events
    }

    override fun onCancel(arguments: Any?) {
        sink = null
    }

    override fun onTagRead(epc: String) {
        sink?.success(mapOf("type" to "tag", "epc" to epc))
    }

    override fun onReadingChanged(isReading: Boolean) {
        sink?.success(mapOf("type" to "reading", "value" to isReading))
    }

    private companion object {
        const val METHOD_CHANNEL = "uz.tatu.rfid/reader"
        const val EVENT_CHANNEL = "uz.tatu.rfid/reader_events"
    }
}
