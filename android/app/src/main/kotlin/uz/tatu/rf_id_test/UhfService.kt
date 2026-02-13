package uz.tatu.rf_id_test

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.Handler
import android.os.Looper
import com.rscja.deviceapi.RFIDWithUHFUART
import com.rscja.deviceapi.entity.UHFTAGInfo
import io.flutter.plugin.common.EventChannel

class UhfService(private val context: Context) {

    private var uhf: RFIDWithUHFUART? = null

    private var inited = false
    private var eventSink: EventChannel.EventSink? = null
    private var isReading = false

    private val mainHandler = Handler(Looper.getMainLooper())

    private val buffer = mutableListOf<String>()
    private var lastEmitTime = 0L

    val streamHandler = object : EventChannel.StreamHandler {
        override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
            eventSink = events
        }

        override fun onCancel(arguments: Any?) {
            eventSink = null
        }
    }

    fun init(): Boolean {
        if (inited) return true
        uhf = RFIDWithUHFUART.getInstance()

        val ok = uhf?.init(context) == true
        if (!ok) return false

        uhf?.setPower(26)

        context.registerReceiver(
            triggerReceiver,
            IntentFilter("android.rfid.FUN_KEY")
        )
        inited = true;
        return true
    }


    private val seen = HashSet<String>()


    fun startReading() {
        if (isReading) return
        isReading = true
        seen.clear()

        uhf?.setInventoryCallback { tagInfo ->
            val epc = tagInfo?.epc ?: return@setInventoryCallback
            if (seen.contains(epc)) return@setInventoryCallback

            seen.add(epc)

            mainHandler.post {
                println("📡 EPC READ → $epc | sink = ${eventSink != null}")
                eventSink?.success(epc)
            }
        }

        uhf?.startInventoryTag()
    }


    fun stopReading() {
        if (!isReading) return
        isReading = false
        uhf?.stopInventory()
    }

    fun setPower(level: Int) {
        uhf?.setPower(level.coerceIn(5, 30))
    }

    fun release() {
        stopReading()
        uhf?.free()
        try {
            context.unregisterReceiver(triggerReceiver)
        } catch (_: Exception) {
        }
    }

    private val triggerReceiver = object : BroadcastReceiver() {
        override fun onReceive(context: Context?, intent: Intent?) {
            if (intent?.action != "android.rfid.FUN_KEY") return

            val keyCode = intent.getIntExtra("keyCode", 0)
            val keyDown = intent.getBooleanExtra("keydown", false)

            if (keyCode == 3) {
                if (keyDown) startReading()
                else stopReading()
            }
        }
    }
}

