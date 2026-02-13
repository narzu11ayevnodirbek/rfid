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
                    println("🔥 [ANDROID] METHOD start RECEIVED")
                    uhfService.startReading()
                    result.success(true)
                }

                "stop" -> {
                    println("🔥 [ANDROID] METHOD stop RECEIVED")
                    uhfService.stopReading()
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

            }
        }
    }
}

