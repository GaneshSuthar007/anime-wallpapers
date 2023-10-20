package app.anime.wallpapers.ui.home

import androidx.lifecycle.ViewModel
import app.anime.wallpapers.network.ApiHelperImpl
import dagger.hilt.android.lifecycle.HiltViewModel
import javax.inject.Inject

@HiltViewModel
class VHHome @Inject constructor(
    private val apiHelper: ApiHelperImpl
) : ViewModel() {

    fun getWallpapers(params: HashMap<String, Any>) = apiHelper.getWallpapers(params)

    fun getCategories(params: HashMap<String, Any>) = apiHelper.getCategories(params)

}