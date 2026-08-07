package uz.uztomic.alifbo

import android.app.Application
import android.util.Log
import androidx.work.Configuration

/**
 * Supplies an on-demand WorkManager configuration (see AndroidManifest.xml,
 * where the default eager androidx-startup initializer for WorkManager is
 * removed). Without this, WorkManager builds its Room database eagerly
 * inside a ContentProvider at process-attach time — before Flutter or any
 * of our own code runs — which is where a crash inside the Google Mobile
 * Ads SDK's own WorkManager usage was observed on-device
 * ("Failed to create an instance of androidx.work.impl.WorkDatabase").
 * On-demand initialization defers that database creation to first actual
 * use, avoiding the startup-time race.
 */
class AlifboApplication : Application(), Configuration.Provider {
    override val workManagerConfiguration: Configuration
        get() = Configuration.Builder()
            .setMinimumLoggingLevel(Log.INFO)
            .build()
}
