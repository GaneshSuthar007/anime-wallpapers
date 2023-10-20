package app.anime.wallpapers.network.data


import com.google.gson.annotations.SerializedName

data class Wallpapers(
    @SerializedName("wallpapers")
    val wallpapers: ArrayList<Data>
) {
    data class Data(
        @SerializedName("id")
        val id: Int,
        @SerializedName("is_premium")
        val isPremium: Boolean,
        @SerializedName("url")
        val url: String
    )
}