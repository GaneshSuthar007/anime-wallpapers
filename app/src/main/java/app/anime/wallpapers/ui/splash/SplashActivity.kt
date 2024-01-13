package app.anime.wallpapers.ui.splash

import android.os.Bundle
import androidx.activity.result.contract.ActivityResultContracts
import androidx.appcompat.app.AppCompatActivity
import app.anime.wallpapers.R
import app.anime.wallpapers.ui.home.HomeActivity
import app.anime.wallpapers.utils.InternetCheck
import app.anime.wallpapers.utils.extensions.openActivity
import app.anime.wallpapers.utils.extensions.showInfoDialog
import com.google.android.play.core.appupdate.AppUpdateManager
import com.google.android.play.core.appupdate.AppUpdateManagerFactory
import com.google.android.play.core.appupdate.AppUpdateOptions
import com.google.android.play.core.install.model.ActivityResult
import com.google.android.play.core.install.model.AppUpdateType
import com.google.android.play.core.install.model.UpdateAvailability


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

        val callback =
            registerForActivityResult(ActivityResultContracts.StartIntentSenderForResult()) { result ->
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
                            openActivity<HomeActivity>()
                            finish()
                        } else {
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
                    openActivity<HomeActivity>()
                    finish()
                } else {
                    showInfoDialog(R.drawable.ic_server_error, R.string.server_error) {
                        finish()
                    }
                }
            }
        }
    }

}