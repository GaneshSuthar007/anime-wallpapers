package app.anime.wallpapers.ui.home.fragments

import android.content.ActivityNotFoundException
import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.view.View
import androidx.core.app.ShareCompat
import app.anime.wallpapers.core.BaseFragment
import app.anime.wallpapers.databinding.FragmentSettingsBinding
import app.anime.wallpapers.ui.content.ContentActivity
import app.anime.wallpapers.ui.home.VHHome
import app.anime.wallpapers.utils.extensions.openActivity


class Settings : BaseFragment<VHHome, FragmentSettingsBinding>() {
    override fun getViewBinding() = FragmentSettingsBinding.inflate(layoutInflater)

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        binding.llHowTo.setOnClickListener {
            requireActivity().openActivity<ContentActivity>(
                "title" to "How to set wallpaper.?",
                "content" to "Step 1. On the Home screen, touch and hold an empty space.\nStep 2. Tap Wallpapers.\nStep 3. Select a category to find wallpaper options.\nStep 4. Select an image.\nStep 5. Tap Set Wallpaper.\nStep 6. Choose where you want to see this wallpaper."
            )
        }

        binding.llDisclaimer.setOnClickListener {
            requireActivity().openActivity<ContentActivity>(
                "title" to "Disclaimer",
                "content" to "All the wallpapers in this app are under common creative license and the credit goes to their respective owners. These images are not endorsed by any of the prospective owners, and the images are used simply for aesthetic purposes. No copyright infringement is intended, and any request to remove one of the images/logos/names will be honored."
            )
        }

        binding.llShare.setOnClickListener {
            ShareCompat.IntentBuilder.from(requireActivity())
                .setType("text/plain")
                .setChooserTitle("Share")
                .setText("http://play.google.com/store/apps/details?id=" + requireActivity().packageName)
                .startChooser();
        }

        binding.llAbout.setOnClickListener {
            try {
                startActivity(Intent(Intent.ACTION_VIEW, Uri.parse("market://details?id=app.anime.wallpapers")))
            } catch (e: ActivityNotFoundException) {
                startActivity(Intent(Intent.ACTION_VIEW, Uri.parse("https://play.google.com/store/apps/details?id=app.anime.wallpapers")))
            }
        }

        binding.llFeedback.setOnClickListener {
            val pInfo = requireActivity().packageManager.getPackageInfo(
                requireActivity().packageName, 0
            )
            val intent = Intent(Intent.ACTION_SENDTO)
            intent.data = Uri.parse("mailto:")
            intent.putExtra(Intent.EXTRA_EMAIL, arrayOf<String>("starpremiumappz@gmail.com"))
            intent.putExtra(Intent.EXTRA_SUBJECT, "App Feedback")
            intent.putExtra(Intent.EXTRA_TEXT,  "\nDo Not Remove this \n App Version ${pInfo.versionName} - ${pInfo.versionCode}")
            if (intent.resolveActivity(requireActivity().packageManager) != null) {
                startActivity(intent)
            }
        }
    }

}