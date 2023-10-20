package app.anime.wallpapers.ui.home.fragments

import android.os.Bundle
import android.view.View
import androidx.recyclerview.widget.GridLayoutManager
import app.anime.wallpapers.core.BaseFragment
import app.anime.wallpapers.databinding.FragmentHomeBinding
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

class Home : BaseFragment<VHHome, FragmentHomeBinding>() {

    private var rewardedAd: RewardedAd? = null
    lateinit var wallpaper : Wallpapers.Data

    override fun getViewBinding() = FragmentHomeBinding.inflate(layoutInflater)

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        getWallpapers()
        val layoutManager = GridLayoutManager(requireActivity(), 2)
        binding.rvWallpapers.layoutManager = layoutManager
    }

    override fun onResume() {
        super.onResume()
        loader.show()
        val adRequest = AdRequest.Builder().build()
        RewardedAd.load(
            requireActivity(),
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
                            requireActivity().openActivity<PreviewActivity>(
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

    private fun getWallpapers() {
        viewModel.getWallpapers(
            hashMapOf<String, Any>(
                "app_id" to 1,
            )
        ).observe(viewLifecycleOwner) {
            wsWithLoader(it) {
                it.data?.let { it ->
                    it.data?.let { data ->
                        val adapter = WallpapersAdapter({ _, data ->
                            wallpaper = data
                            if (data.isPremium) {
                                rewardedAd?.show(requireActivity(),
                                    OnUserEarnedRewardListener {

                                    })
                            } else {
                                requireActivity().openActivity<PreviewActivity>(
                                    "id" to data.id,
                                    "url" to data.url
                                )
                            }
                        }, data.wallpapers)
                        binding.rvWallpapers.adapter = adapter
                    }
                }
            }
        }
    }

}