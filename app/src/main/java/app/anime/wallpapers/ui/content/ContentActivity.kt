package app.anime.wallpapers.ui.content

import app.anime.wallpapers.core.BaseActivity
import app.anime.wallpapers.databinding.ActivityContentBinding
import app.anime.wallpapers.ui.home.VHHome
import com.google.android.gms.ads.AdRequest
import dagger.hilt.android.AndroidEntryPoint

@AndroidEntryPoint
class ContentActivity : BaseActivity<VHHome, ActivityContentBinding>() {
    override fun getViewBinding() = ActivityContentBinding.inflate(layoutInflater)


    override fun onRendered(viewModel: VHHome, binding: ActivityContentBinding) {
        super.onRendered(viewModel, binding)
        binding.apply {
            title = intent.getStringExtra("title")
            content = intent.getStringExtra("content")
        }
        val adRequest = AdRequest.Builder().build()
        binding.adView.loadAd(adRequest)
    }

}