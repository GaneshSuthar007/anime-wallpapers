package app.anime.wallpapers.network.data


import com.google.gson.annotations.SerializedName

data class Categories(
    @SerializedName("categories")
    val categories: ArrayList<Category>
) {
    data class Category(
        @SerializedName("app")
        val app: App,
        @SerializedName("id")
        val id: Int,
        @SerializedName("name")
        val name: String,
        @SerializedName("url")
        val url: String
    ) {
        data class App(
            @SerializedName("id")
            val id: Int,
            @SerializedName("name")
            val name: String
        )
    }
}