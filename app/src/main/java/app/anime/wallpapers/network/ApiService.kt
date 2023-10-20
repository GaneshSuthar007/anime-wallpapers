package app.anime.wallpapers.network

import app.anime.wallpapers.network.data.BaseResponse
import app.anime.wallpapers.network.data.Categories
import app.anime.wallpapers.network.data.Wallpapers
import app.anime.wallpapers.utils.ApiConstants
import retrofit2.Response
import retrofit2.http.*

interface ApiService {

    @GET(ApiConstants.wallpapers)
    suspend fun getWallpapers(@QueryMap hashMap: HashMap<String, Any>): Response<BaseResponse<Wallpapers>>

    @GET(ApiConstants.categories)
    suspend fun getCategories(@QueryMap hashMap: HashMap<String, Any>): Response<BaseResponse<Categories>>
}