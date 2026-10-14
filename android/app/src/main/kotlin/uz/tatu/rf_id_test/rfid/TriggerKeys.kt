package uz.tatu.rf_id_test.rfid

import android.view.KeyEvent

/**
 * Hardware keys that work as the scan trigger on supported handhelds.
 *
 * To support a new model, open Settings → Reader diagnostics in the app,
 * press the trigger and add the key code shown there.
 */
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
