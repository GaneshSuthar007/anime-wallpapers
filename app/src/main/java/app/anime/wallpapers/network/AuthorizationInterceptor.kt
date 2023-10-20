package app.anime.wallpapers.network

import android.content.Context
import app.anime.wallpapers.utils.ApiConstants
import okhttp3.Interceptor
import okhttp3.Request
import okhttp3.Response

class AuthorizationInterceptor(private val context: Context) : Interceptor {
    override fun intercept(chain: Interceptor.Chain): Response {
        val newRequest: Request = chain.request().newBuilder()
            .addHeader("api_key", ApiConstants.APIKEY)
            .build()
        return chain.proceed(newRequest)
    }
}
