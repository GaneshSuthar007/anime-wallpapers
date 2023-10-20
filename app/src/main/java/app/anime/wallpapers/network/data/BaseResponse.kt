package app.anime.wallpapers.network.data

open class BaseResponse<T> {
    var message: String = ""
    var status: Int = 200
    var data: T? = null
}