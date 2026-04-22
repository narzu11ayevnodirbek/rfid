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

    private var singleShot = true          // xohlasangiz false qilib multi qoldirasiz
    private var emittedThisPress = false   // shu bosishda 1 martagina chiqarish

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

        triggerEnabled = false
        stopReading()
        inited = true;
        return true
    }


    private val seen = HashSet<String>()


    fun startReading() {
        println("🚀 startReading called. isReading=$isReading uhfNull=${uhf==null}")
        if (isReading) return
        isReading = true
        seen.clear()
        emittedThisPress = false

        uhf?.setInventoryCallback { tagInfo ->
            val epc = tagInfo?.epc ?: return@setInventoryCallback
            if (epc.isBlank()) return@setInventoryCallback
            // 1 press = 1 EPC
            if (singleShot && emittedThisPress) return@setInventoryCallback
            println("📡 CALLBACK EPC=$epc")
            if (seen.contains(epc)) return@setInventoryCallback
            seen.add(epc)
            emittedThisPress = true
            mainHandler.post {
                println("📡 EPC EMIT → $epc | sink=${eventSink != null}")
                eventSink?.success(epc)
            }
            if (singleShot) {
                mainHandler.post { stopReading() }
            }
        }

        val ok = uhf?.startInventoryTag()
        println("🚀 startInventoryTag() result=$ok")
    }

    private var triggerEnabled = false

    fun setTriggerEnabled(enabled: Boolean) {
        triggerEnabled = enabled
        if (!enabled) stopReading()
    }


    fun stopReading() {
        if (!isReading) return
        isReading = false
        uhf?.stopInventory()
        emittedThisPress = false
    }

    fun setPower(level: Int) {
        uhf?.setPower(level.coerceIn(5, 30))
    }

    fun release() {
        stopReading()
        uhf?.free()
        uhf = null
        inited = false
    }

    fun isTriggerArmed(): Boolean = triggerEnabled
}

