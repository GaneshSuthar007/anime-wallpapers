package app.anime.wallpapers.utils

object ApiConstants {
    //var BASEURL = "https://magenta-rose-cod-gear.cyclic.app/v1/api/"
    var BASEURL = "https://9a40-2401-4900-1c1a-133e-dd8c-38c2-2763-d0c9.ngrok.io/v1/api/"
    var APIKEY = "f4371ab7-2a36-4fe1-9d9f-7e309c30aaf6"

    const val wallpapers = "get-wallpapers"
    const val categories = "get-categories"
}

object PrefConstants {
    const val user = "user"
    const val authToken = "auth-token"
    const val authRefreshToken = "auth-refresh-token"
    const val fcmToken = "fcm-token"
    const val isAuth = "is-auth"
}

object Env {
    val environment = Environments.DEVELOPMENT
}

enum class Environments {
    DEVELOPMENT,
    PRODUCTION
}


