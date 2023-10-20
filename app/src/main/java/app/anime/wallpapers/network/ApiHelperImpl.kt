package app.anime.wallpapers.network

import app.anime.wallpapers.utils.ApiConstants
import javax.inject.Inject

class ApiHelperImpl @Inject constructor(private val apiService: ApiService) : BaseDataSource() {

    fun getWallpapers(params: HashMap<String, Any>) = performOperation(ApiConstants.wallpapers) {
        getResult(ApiConstants.wallpapers) {
            apiService.getWallpapers(params)
        }
    }

    fun getCategories(params: HashMap<String, Any>) = performOperation(ApiConstants.wallpapers) {
        getResult(ApiConstants.wallpapers) {
            apiService.getCategories(params)
        }
    }

}