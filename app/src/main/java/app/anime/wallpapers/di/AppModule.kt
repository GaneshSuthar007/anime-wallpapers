package app.anime.wallpapers.di

import android.content.Context
import android.content.SharedPreferences
import app.anime.wallpapers.network.ApiHelperImpl
import app.anime.wallpapers.network.ApiService
import app.anime.wallpapers.network.AuthorizationInterceptor
import app.anime.wallpapers.utils.ApiConstants
import app.anime.wallpapers.utils.preferences.PrefManager
import dagger.Module
import dagger.Provides
import dagger.hilt.InstallIn
import dagger.hilt.android.qualifiers.ApplicationContext
import dagger.hilt.components.SingletonComponent
import okhttp3.OkHttpClient
import okhttp3.logging.HttpLoggingInterceptor
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory
import java.util.concurrent.TimeUnit
import javax.inject.Singleton

@Module
@InstallIn(SingletonComponent::class)
object AppModule {

    @Provides
    @Singleton
    fun provideBaseUrl() = ApiConstants.BASEURL

    @Provides
    @Singleton
    fun provideSharedPreference(@ApplicationContext context: Context): SharedPreferences {
        return context.getSharedPreferences("wallpaper", Context.MODE_PRIVATE)
    }

    @Provides
    @Singleton
    fun providePrefManager(sharedPreferences: SharedPreferences): PrefManager {
        return PrefManager(sharedPreferences)
    }

    @Provides
    @Singleton
    fun provideOkHttpClient(@ApplicationContext context: Context) = run {
        val loggingInterceptor = HttpLoggingInterceptor()
        loggingInterceptor.setLevel(HttpLoggingInterceptor.Level.BODY)
        OkHttpClient.Builder()
            .addInterceptor(AuthorizationInterceptor(context))
            .addInterceptor(loggingInterceptor)
            .readTimeout(3, TimeUnit.MINUTES)
            .writeTimeout(3, TimeUnit.MINUTES)
            .build()
    }

    @Provides
    @Singleton
    fun provideRetrofit(okHttpClient: OkHttpClient, BASE_URL: String): Retrofit = Retrofit.Builder()
        .addConverterFactory(GsonConverterFactory.create())
        .baseUrl(BASE_URL)
        .client(okHttpClient)
        .build()

    @Provides
    @Singleton
    fun provideApiService(retrofit: Retrofit): ApiService = retrofit.create(ApiService::class.java)

    @Provides
    @Singleton
    fun provideRemoteRepo(@ApplicationContext context: Context, apiService: ApiService): ApiHelperImpl = ApiHelperImpl(apiService)


}