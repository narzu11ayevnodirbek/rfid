package uz.tatu.rf_id_test.rfid

import android.content.Context
import android.os.Handler
import android.os.Looper
import com.rscja.deviceapi.RFIDWithUHFUART
import java.util.concurrent.Executors

class UhfReader(
    private val context: Context,
    private val listener: Listener,
) {
    interface Listener {
        fun onTagRead(epc: String)

        fun onReadingChanged(isReading: Boolean)
    }

    enum class InitResult { READY, INIT_FAILED, UNAVAILABLE }

    private val mainHandler = Handler(Looper.getMainLooper())
    private val worker = Executors.newSingleThreadExecutor()
    private val seenInBurst = HashSet<String>()

    private var module: RFIDWithUHFUART? = null

    var isArmed = false
        private set

    var isReading = false
        private set

    // Powering the module on blocks for a moment, so it runs on a worker thread.
    fun initialize(onResult: (InitResult) -> Unit) {
        if (module != null) {
            onResult(InitResult.READY)
            return
        }
        worker.execute {
            var instance: RFIDWithUHFUART? = null
            val result = try {
                instance = RFIDWithUHFUART.getInstance()
                if (instance.init(context)) InitResult.READY else InitResult.INIT_FAILED
            } catch (error: Throwable) {
                InitResult.UNAVAILABLE
            }
            mainHandler.post {
                if (result == InitResult.READY) {
                    module = instance
                    instance?.setPower(DEFAULT_POWER_DBM)
                }
                onResult(result)
            }
        }
    }

    fun setPower(dbm: Int): Boolean =
        module?.setPower(dbm.coerceIn(MIN_POWER_DBM, MAX_POWER_DBM)) ?: false

    fun arm(readImmediately: Boolean): Boolean {
        if (module == null) return false
        isArmed = true
        if (readImmediately && !startReading()) {
            isArmed = false
            return false
        }
        return true
    }

    fun disarm() {
        isArmed = false
        stopReading()
    }

    fun startReading(): Boolean {
        val uhf = module ?: return false
        if (isReading) return true
        synchronized(seenInBurst) { seenInBurst.clear() }
        uhf.setInventoryCallback { tagInfo ->
            // Called on the SDK's thread.
            val epc = tagInfo?.epc
            if (epc.isNullOrBlank()) return@setInventoryCallback
            val isNew = synchronized(seenInBurst) { seenInBurst.add(epc) }
            if (isNew) mainHandler.post { listener.onTagRead(epc) }
        }
        if (!uhf.startInventoryTag()) return false
        isReading = true
        listener.onReadingChanged(true)
        return true
    }

    fun stopReading() {
        if (!isReading) return
        module?.stopInventory()
        isReading = false
        listener.onReadingChanged(false)
    }

    fun shutdown() {
        disarm()
        module?.free()
        module = null
        worker.shutdown()
    }

    private companion object {
        const val MIN_POWER_DBM = 5
        const val MAX_POWER_DBM = 30
        const val DEFAULT_POWER_DBM = 26
    }
}
