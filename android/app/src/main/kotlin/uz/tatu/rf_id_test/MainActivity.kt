package uz.tatu.rf_id_test

import android.view.KeyEvent
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import uz.tatu.rf_id_test.rfid.RfidChannel

class MainActivity : FlutterActivity() {

    private var rfid: RfidChannel? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        rfid = RfidChannel(applicationContext, flutterEngine.dartExecutor.binaryMessenger)
    }

    override fun onKeyDown(keyCode: Int, event: KeyEvent): Boolean {
        val handled = rfid?.onKey(keyCode, isDown = true, repeatCount = event.repeatCount) == true
        return handled || super.onKeyDown(keyCode, event)
    }

    override fun onKeyUp(keyCode: Int, event: KeyEvent): Boolean {
        val handled = rfid?.onKey(keyCode, isDown = false, repeatCount = 0) == true
        return handled || super.onKeyUp(keyCode, event)
    }

    override fun onPause() {
        rfid?.pauseReading()
        super.onPause()
    }

    override fun onDestroy() {
        rfid?.dispose()
        rfid = null
        super.onDestroy()
    }
}
