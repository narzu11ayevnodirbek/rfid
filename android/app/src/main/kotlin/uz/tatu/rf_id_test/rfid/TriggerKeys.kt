package uz.tatu.rf_id_test.rfid

import android.view.KeyEvent

// Add a new model's trigger code here; Settings → Reader diagnostics in the
// app shows it.
object TriggerKeys {
    private val codes = setOf(
        293,
        KeyEvent.KEYCODE_F9,
        KeyEvent.KEYCODE_F10,
        KeyEvent.KEYCODE_F11,
        KeyEvent.KEYCODE_F12,
        KeyEvent.KEYCODE_BUTTON_L1,
        KeyEvent.KEYCODE_BUTTON_R1,
    )

    fun isTrigger(keyCode: Int): Boolean = keyCode in codes
}
