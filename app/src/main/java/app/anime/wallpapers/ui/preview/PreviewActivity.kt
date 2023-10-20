package app.anime.wallpapers.ui.preview

import android.app.WallpaperManager
import android.content.Intent
import android.graphics.Bitmap
import android.net.Uri
import android.view.View
import app.anime.wallpapers.core.BaseActivity
import app.anime.wallpapers.databinding.ActivityPreviewBinding
import app.anime.wallpapers.ui.home.VHHome
import app.anime.wallpapers.utils.extensions.snack
import com.google.android.gms.ads.AdRequest
import com.google.android.gms.ads.LoadAdError
import com.google.android.gms.ads.interstitial.InterstitialAd
import com.google.android.gms.ads.interstitial.InterstitialAdLoadCallback
import com.google.android.material.snackbar.Snackbar
import com.nostra13.universalimageloader.core.ImageLoader
import com.nostra13.universalimageloader.core.assist.FailReason
import com.nostra13.universalimageloader.core.listener.SimpleImageLoadingListener
import dagger.hilt.android.AndroidEntryPoint
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext


@AndroidEntryPoint
class PreviewActivity : BaseActivity<VHHome, ActivityPreviewBinding>() {
    private var mInterstitialAd: InterstitialAd? = null

    lateinit var bitmap: Bitmap
    private val imageLoader: ImageLoader = ImageLoader.getInstance()

    override fun getViewBinding() = ActivityPreviewBinding.inflate(layoutInflater)

    override fun onRendered(viewModel: VHHome, binding: ActivityPreviewBinding) {
        super.onRendered(viewModel, binding)
        binding.apply {
            url = intent.getStringExtra("url")
        }
        getBitmapFromUrl(intent.getStringExtra("url")!!)

        binding.cvLock.setOnClickListener {
            applyWallpaper(1, bitmap)
        }
        binding.cvHome.setOnClickListener {
            applyWallpaper(2, bitmap)
        }
        binding.cvReport.setOnClickListener {
            sendEmail(intent.getIntExtra("id", 0))
        }
        val adRequest = AdRequest.Builder().build()
        binding.adView.loadAd(adRequest)
        prepareAd()
    }

    private fun getBitmapFromUrl(imageUrl: String) {
        imageLoader.loadImage(imageUrl, object : SimpleImageLoadingListener() {
            override fun onLoadingComplete(
                imageUri: String?,
                view: View?,
                loadedImage: Bitmap?
            ) {
                super.onLoadingComplete(imageUri, view, loadedImage)
                bitmap = loadedImage!!
                loader.hide()

            }

            override fun onLoadingFailed(
                imageUri: String?,
                view: View?,
                failReason: FailReason?
            ) {
                super.onLoadingFailed(imageUri, view, failReason)
                loader.hide()
            }

            override fun onLoadingStarted(imageUri: String?, view: View?) {
                super.onLoadingStarted(imageUri, view)
                loader.show()
            }
        })
//        CoroutineScope(Dispatchers.IO).launch {
//
//
//            withContext(Dispatchers.Main) {
//
//            }
//        }
    }

    private fun applyWallpaper(screen: Int, bitmap: Bitmap) {
        loader.show()
        CoroutineScope(Dispatchers.IO).launch {
            val wallpaperManager = WallpaperManager.getInstance(applicationContext)
            if (screen == 1) {
                wallpaperManager.setBitmap(bitmap, null, true, WallpaperManager.FLAG_LOCK);
            } else {
                wallpaperManager.setBitmap(bitmap, null, true, WallpaperManager.FLAG_SYSTEM);
            }
            withContext(Dispatchers.Main) {
                loader.cancel()
                binding.root.snack(
                    "Wallpaper applied successfully",
                    Snackbar.LENGTH_SHORT
                ) {
                    mInterstitialAd?.show(this@PreviewActivity)
                }

            }
        }
    }

    private fun prepareAd() {
        val adRequest = AdRequest.Builder().build()
        InterstitialAd.load(
            this,
            "ca-app-pub-1032142226898733/5988889628",
            adRequest,
            object : InterstitialAdLoadCallback() {
                override fun onAdFailedToLoad(adError: LoadAdError) {
                    mInterstitialAd = null
                }

                override fun onAdLoaded(interstitialAd: InterstitialAd) {
                    mInterstitialAd = interstitialAd
                }
            })

    }

    private fun sendEmail(id: Int) {
        val intent = Intent(Intent.ACTION_SENDTO)
        intent.data = Uri.parse("mailto:")
        intent.putExtra(Intent.EXTRA_EMAIL, arrayOf<String>("starpremiumappz@gmail.com"))
        intent.putExtra(Intent.EXTRA_SUBJECT, "Report Wallpaper")
        intent.putExtra(Intent.EXTRA_TEXT, "\nDo Not Remove this Wallpaper ID $id")
        if (intent.resolveActivity(packageManager) != null) {
            startActivity(intent)
        }
    }

}