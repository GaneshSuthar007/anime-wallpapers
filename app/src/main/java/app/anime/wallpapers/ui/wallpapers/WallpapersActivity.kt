package app.anime.wallpapers.ui.wallpapers

import androidx.recyclerview.widget.GridLayoutManager
import app.anime.wallpapers.core.BaseActivity
import app.anime.wallpapers.databinding.ActivityWallpapersBinding
import app.anime.wallpapers.network.data.Wallpapers
import app.anime.wallpapers.ui.home.VHHome
import app.anime.wallpapers.ui.home.adapters.WallpapersAdapter
import app.anime.wallpapers.ui.preview.PreviewActivity
import app.anime.wallpapers.utils.extensions.openActivity
import app.anime.wallpapers.utils.extensions.snack
import com.google.android.gms.ads.AdError
import com.google.android.gms.ads.AdRequest
import com.google.android.gms.ads.FullScreenContentCallback
import com.google.android.gms.ads.LoadAdError
import com.google.android.gms.ads.OnUserEarnedRewardListener
import com.google.android.gms.ads.rewarded.RewardedAd
import com.google.android.gms.ads.rewarded.RewardedAdLoadCallback
import dagger.hilt.android.AndroidEntryPoint

@AndroidEntryPoint
class WallpapersActivity : BaseActivity<VHHome, ActivityWallpapersBinding>() {

    override fun getViewBinding() = ActivityWallpapersBinding.inflate(layoutInflater)

    private var rewardedAd: RewardedAd? = null
    lateinit var wallpaper : Wallpapers.Data

    override fun onRendered(viewModel: VHHome, binding: ActivityWallpapersBinding) {
        super.onRendered(viewModel, binding)
        getWallpapers()
        val layoutManager = GridLayoutManager(this@WallpapersActivity, 2)
        binding.rvWallpapers.layoutManager = layoutManager
        binding.tvTitle.text = intent.getStringExtra("category_name")

        val adRequest = AdRequest.Builder().build()
        binding.adView.loadAd(adRequest)
    }

    private fun getWallpapers() {
        viewModel.getWallpapers(
            hashMapOf<String, Any>(
                "app_id" to 1,
               "category_id" to intent.getIntExtra("category_id",0)
            )
        ).observe(this) {
            wsWithLoader(it) {
                it.data?.let { it ->
                    it.data?.let { data ->
                        val adapter = WallpapersAdapter({ _, data ->
                            wallpaper = data
                            if (data.isPremium) {
                                rewardedAd?.show(this,
                                    OnUserEarnedRewardListener {

                                    })
                            } else {
                                openActivity<PreviewActivity>(
                                    "id" to data.id,
                                    "url" to data.url
                                )
                            }

                        },data.wallpapers)
                        binding.rvWallpapers.adapter = adapter
                    }
                }
            }
        }
    }

    override fun onResume() {
        super.onResume()
        loader.show()
        val adRequest = AdRequest.Builder().build()
        RewardedAd.load(
            this,
            "ca-app-pub-1032142226898733/6875946950",
            adRequest,
            object : RewardedAdLoadCallback() {
                override fun onAdFailedToLoad(adError: LoadAdError) {
                    rewardedAd = null
                    loader.cancel()
                }

                override fun onAdLoaded(ad: RewardedAd) {
                    loader.cancel()
                    rewardedAd = ad
                    rewardedAd?.fullScreenContentCallback = object : FullScreenContentCallback() {

                        override fun onAdDismissedFullScreenContent() {
                            super.onAdDismissedFullScreenContent()
                            openActivity<PreviewActivity>(
                                "id" to wallpaper.id,
                                "url" to wallpaper.url
                            )
                        }
                        override fun onAdFailedToShowFullScreenContent(p0: AdError) {
                            super.onAdFailedToShowFullScreenContent(p0)
                            binding.root.snack("Failed to unlock wallpaper try again later"){}
                        }
                    }
                }
            })
    }
}