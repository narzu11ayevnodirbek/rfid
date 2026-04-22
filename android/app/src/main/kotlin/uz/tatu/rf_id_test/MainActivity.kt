package uz.tatu.rf_id_test

import android.widget.Toast
import com.rscja.barcode.BarcodeDecoder
import com.rscja.barcode.BarcodeFactory
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import io.flutter.plugin.common.EventChannel
import android.view.KeyEvent

class MainActivity : FlutterActivity() {

    private lateinit var uhfService: UhfService

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        uhfService = UhfService(this)

        EventChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "rfid_event_channel"
        ).setStreamHandler(uhfService.streamHandler)


        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "rfid_channel"
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "initTask" -> {
                    println("🔥 [ANDROID] METHOD initTask RECEIVED")
                    val ok = uhfService.init()
                    println("UHF INIT RESULT → $ok")
                    result.success(ok)
                }

                "start" -> {
                    println("🔥 [ANDROID] METHOD start RECEIVED (ARM TRIGGER ONLY)")
                    uhfService.setTriggerEnabled(true)   // faqat triggerga ruxsat
                    result.success(true)
                }

                "stop" -> {
                    println("🔥 [ANDROID] METHOD stop RECEIVED (DISARM)")
                    uhfService.setTriggerEnabled(false)  // trigger o'chadi va o'qish ham to'xtaydi
                    result.success(true)
                }

                "close" -> {
                    uhfService.release()
                    result.success(true)
                }

                "setPower" -> {
                    val level = call.argument<Int>("level") ?: 26
                    uhfService.setPower(level)
                    result.success(true)
                }

                "setTriggerEnabled" -> {
                    val enabled = call.argument<Boolean>("enabled") ?: true
                    uhfService.setTriggerEnabled(enabled)
//                    println("🎯 TRIGGER keyCode=$keyCode keyDown=$keyDown enabled=$triggerEnabled")
                    result.success(true)
                }

            }
        }
    }

    override fun onKeyDown(keyCode: Int, event: KeyEvent): Boolean {
        // DEBUG: qaysi knopka ekanini bilish uchun
        println("⌨️ onKeyDown keyCode=$keyCode")

        // faqat ARM bo'lganda ishlasin
        if (uhfService.isTriggerArmed()) {
            // ko'p qurilmalarda trigger shu tugmalardan biri bo'ladi
            if (keyCode == 293 || keyCode == KeyEvent.KEYCODE_F9 ||
                keyCode == KeyEvent.KEYCODE_F10 ||
                keyCode == KeyEvent.KEYCODE_F11 ||
                keyCode == KeyEvent.KEYCODE_F12 ||
                keyCode == KeyEvent.KEYCODE_BUTTON_L1 ||
                keyCode == KeyEvent.KEYCODE_BUTTON_R1
            ) {
                uhfService.startReading()
                return true
            }
        }
        return super.onKeyDown(keyCode, event)
    }

    override fun onKeyUp(keyCode: Int, event: KeyEvent): Boolean {
        println("⌨️ onKeyUp keyCode=$keyCode")

        if (uhfService.isTriggerArmed()) {
            if (keyCode == 293 || keyCode == KeyEvent.KEYCODE_F9 ||
                keyCode == KeyEvent.KEYCODE_F10 ||
                keyCode == KeyEvent.KEYCODE_F11 ||
                keyCode == KeyEvent.KEYCODE_F12 ||
                keyCode == KeyEvent.KEYCODE_BUTTON_L1 ||
                keyCode == KeyEvent.KEYCODE_BUTTON_R1
            ) {
                uhfService.stopReading()
                return true
            }
        }
        return super.onKeyUp(keyCode, event)
    }




}

