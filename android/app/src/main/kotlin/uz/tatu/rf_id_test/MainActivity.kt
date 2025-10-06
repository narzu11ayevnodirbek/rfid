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

class MainActivity : FlutterActivity() {

    private val barcodeDecoder: BarcodeDecoder = BarcodeFactory.getInstance().barcodeDecoder


    companion object {
        private const val CHANNEL = "rfid_channel"
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL,
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "initTask" -> initTask(result)

                "start" -> start()

                "stop" -> stop()

                "close" -> close()
            }
        }
    }

    private fun initTask(result: MethodChannel.Result) {
        CoroutineScope(Dispatchers.IO).launch {
            try {
                open()
                withContext(Dispatchers.Main) {
                    result.success("success")
                }
            } catch (e: Exception) {
                withContext(Dispatchers.Main) {
                    result.error("INIT_FAILED", e.message, null)
                }
            }
        }
    }

    private fun start() {
        barcodeDecoder.startScan()
    }

    private fun stop() {
        barcodeDecoder.stopScan()
    }

    private fun open() {
        barcodeDecoder.open(this)

        /*TODO
        BarcodeUtility.getInstance().setPrefix(this,"");
        BarcodeUtility.getInstance().setSuffix(this,"");
        BarcodeUtility.getInstance().enablePlaySuccessSound(this,true); //success Sound
        BarcodeUtility.getInstance().enableVibrate(this,true);//vibrate
        BarcodeUtility.getInstance().enableEnter(this,true);//addition enter

        BarcodeUtility.getInstance().enableContinuousScan(this,true);//Continuous scanning
        BarcodeUtility.getInstance().setContinuousScanIntervalTime(this,100);//Unit: milliseconds
        BarcodeUtility.getInstance().setContinuousScanTimeOut(this,9999);//Unit: milliseconds
        */
        barcodeDecoder.setDecodeCallback { barcodeEntity ->
            if (barcodeEntity?.resultCode == BarcodeDecoder.DECODE_SUCCESS) {
                Toast.makeText(
                    this@MainActivity, "data:" + barcodeEntity.barcodeData, Toast.LENGTH_SHORT
                ).show()
            } else {
                Toast.makeText(
                    this@MainActivity, "fail", Toast.LENGTH_SHORT
                ).show()
            }
        }
    }

    private fun close() {
        barcodeDecoder.close()
    }

}
