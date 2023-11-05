package app.anime.wallpapers.ui.splash

import android.os.Bundle
import androidx.activity.result.contract.ActivityResultContracts
import androidx.appcompat.app.AppCompatActivity
import androidx.lifecycle.Observer
import androidx.work.BackoffPolicy
import androidx.work.Constraints
import androidx.work.NetworkType
import androidx.work.OneTimeWorkRequestBuilder
import androidx.work.WorkInfo.State.BLOCKED
import androidx.work.WorkInfo.State.CANCELLED
import androidx.work.WorkInfo.State.ENQUEUED
import androidx.work.WorkInfo.State.FAILED
import androidx.work.WorkInfo.State.RUNNING
import androidx.work.WorkInfo.State.SUCCEEDED
import androidx.work.WorkManager
import app.anime.wallpapers.R
import app.anime.wallpapers.ui.home.HomeActivity
import app.anime.wallpapers.utils.InternetCheck
import app.anime.wallpapers.utils.extensions.openActivity
import app.anime.wallpapers.utils.extensions.showInfoDialog
import app.anime.wallpapers.workers.FirebaseToken
import com.google.android.play.core.appupdate.AppUpdateManager
import com.google.android.play.core.appupdate.AppUpdateManagerFactory
import com.google.android.play.core.appupdate.AppUpdateOptions
import com.google.android.play.core.install.model.ActivityResult
import com.google.android.play.core.install.model.AppUpdateType
import com.google.android.play.core.install.model.UpdateAvailability
import java.util.concurrent.TimeUnit


class SplashActivity : AppCompatActivity() {

    private lateinit var appUpdateManager: AppUpdateManager
    private val inAppUpdateCode = 123

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_splash)
        appUpdateManager = AppUpdateManagerFactory.create(this)
        initInAppUpdater()
    }
    private fun initInAppUpdater() {
        val appUpdateInfoTask = appUpdateManager.appUpdateInfo

        val callback =  registerForActivityResult(ActivityResultContracts.StartIntentSenderForResult()) { result ->
            if (result.resultCode == inAppUpdateCode) {
                when (result.resultCode) {
                    RESULT_CANCELED -> {
                        showInfoDialog(
                            R.drawable.ic_app_updating,
                            R.string.updating_error
                        ) {
                            finish()
                        }
                    }

                    ActivityResult.RESULT_IN_APP_UPDATE_FAILED -> {
                        showInfoDialog(
                            R.drawable.ic_app_updating,
                            R.string.updating_error
                        ) {
                            finish()
                        }
                    }
                }
            }
        }

        appUpdateInfoTask.addOnSuccessListener { appUpdateInfo ->
            when {
                appUpdateInfo.updateAvailability() == UpdateAvailability.UPDATE_AVAILABLE -> {
                    appUpdateManager.startUpdateFlowForResult(
                        appUpdateInfo,
                        callback,
                        AppUpdateOptions.newBuilder(AppUpdateType.IMMEDIATE).build()
                    )
                }

                appUpdateInfo.updateAvailability() == UpdateAvailability.DEVELOPER_TRIGGERED_UPDATE_IN_PROGRESS -> {
                    showInfoDialog(R.drawable.ic_app_updating, R.string.updating_app) {
                        finish()
                    }
                }

                else -> {
                    InternetCheck { internet ->
                        if (internet) {
                            initWorkers()
                        }else{
                            showInfoDialog(R.drawable.ic_server_error, R.string.server_error) {
                                finish()
                            }
                        }
                    }
                }
            }
        }
        appUpdateInfoTask.addOnFailureListener { it ->
            it.printStackTrace()
            InternetCheck { internet ->
                if (internet) {
                    initWorkers()
                }else{
                    showInfoDialog(R.drawable.ic_server_error, R.string.server_error) {
                        finish()
                    }
                }
            }
        }
    }

    private fun initWorkers() {
        val constraints =
            Constraints.Builder().setRequiredNetworkType(NetworkType.CONNECTED).build()
        val tokenWorkRequest = OneTimeWorkRequestBuilder<FirebaseToken>()
            .setConstraints(constraints)
            .setBackoffCriteria(BackoffPolicy.EXPONENTIAL, 5, TimeUnit.SECONDS)
            .build()
        val workManager = WorkManager.getInstance(this)
        workManager
            .beginWith(tokenWorkRequest)
            .enqueue()
        workManager.getWorkInfoByIdLiveData(tokenWorkRequest.id).observe(this, Observer {
            when (it.state) {
                SUCCEEDED -> {
                    openActivity<HomeActivity>()
                    finish()
                }

                FAILED -> {
                    showInfoDialog(R.drawable.ic_server_error, R.string.server_error) {
                        finish()
                    }
                }

                ENQUEUED -> {

                }

                RUNNING -> {}
                BLOCKED -> {}
                CANCELLED -> {}
            }
        })
    }

}