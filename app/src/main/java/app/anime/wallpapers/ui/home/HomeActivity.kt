package app.anime.wallpapers.ui.home

import androidx.navigation.findNavController
import androidx.navigation.ui.setupWithNavController
import app.anime.wallpapers.R
import app.anime.wallpapers.core.BaseActivity
import app.anime.wallpapers.databinding.ActivityHomeBinding
import com.google.android.gms.ads.AdRequest
import dagger.hilt.android.AndroidEntryPoint

@AndroidEntryPoint
class HomeActivity : BaseActivity<VHHome, ActivityHomeBinding>() {

    override fun getViewBinding() = ActivityHomeBinding.inflate(layoutInflater)

    override fun onRendered(viewModel: VHHome, binding: ActivityHomeBinding) {
        super.onRendered(viewModel, binding)
        val navController = findNavController(R.id.nav_host_fragment_activity_home)
        navController.graph = navController.navInflater.inflate(R.navigation.mobile_navigation)
        binding.navView.setupWithNavController(navController)

        val adRequest = AdRequest.Builder().build()
        binding.adView.loadAd(adRequest)

        navController.addOnDestinationChangedListener { _, destination, _ ->
            when (destination.id) {
                R.id.navigation_home -> {
                    binding.tvTitle.setText(R.string.app_name)
                }

                R.id.navigation_categories -> {
                    binding.tvTitle.setText(R.string.title_categories)
                }

                R.id.navigation_settings -> {
                    binding.tvTitle.setText(R.string.title_settings)
                }
            }
        }
    }
}