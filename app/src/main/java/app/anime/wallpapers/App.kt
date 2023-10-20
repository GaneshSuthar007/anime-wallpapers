package app.anime.wallpapers

import android.app.Application
import android.content.Context
import app.anime.wallpapers.utils.AppOpenManager
import com.google.android.gms.ads.MobileAds
import com.google.android.gms.ads.RequestConfiguration
import com.nostra13.universalimageloader.core.DisplayImageOptions
import com.nostra13.universalimageloader.core.ImageLoader
import com.nostra13.universalimageloader.core.ImageLoaderConfiguration
import dagger.hilt.android.HiltAndroidApp

@HiltAndroidApp
class App : Application() {

    private lateinit var appOpenManager: AppOpenManager

    override fun onCreate() {
        super.onCreate()
        val context: Context = this
        val defaultOptions = DisplayImageOptions.Builder()
            .cacheInMemory(false)
            .cacheOnDisk(false)
            .build()
        val config = ImageLoaderConfiguration.Builder(context)
            .defaultDisplayImageOptions(defaultOptions)
            .build()
        ImageLoader.getInstance().init(config)


        val configuration = RequestConfiguration.Builder()
            .setTestDeviceIds(listOf("662B88B17E510F29B5ABF8010D6F8805")).build()
        MobileAds.setRequestConfiguration(configuration)
        MobileAds.initialize(
            this
        )
        appOpenManager = AppOpenManager(this)
    }

}
