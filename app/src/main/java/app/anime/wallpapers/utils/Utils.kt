package app.anime.wallpapers.utils

import android.content.Context
import android.os.Build
import android.text.Html
import java.io.IOException


object Utils {
    fun getJsonDataFromAsset(context: Context, fileName: String): String {
        return try {
            context.assets.open(fileName).bufferedReader().use { it.readText() }
        } catch (ioException: IOException) {
            ioException.printStackTrace()
            ""
        }
    }

    fun getHtmlString(input: String): String {
        val description =
            Html.fromHtml(
                input,
                Html.FROM_HTML_MODE_LEGACY
            ).toString()
        return description
    }

}