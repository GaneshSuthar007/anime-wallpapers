package app.anime.wallpapers

import android.app.WallpaperManager
import android.graphics.BitmapFactory
import android.os.Build.VERSION
import android.os.Build.VERSION_CODES
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.IOException


class MainActivity : FlutterActivity() {
    private val CHANNEL = "wallpaper"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->
            if (call.method == "setWallpaperFromFile") {
                val wallpaper = setWallpaperFromFile(
                    call.argument("filePath")!!,
                    call.argument("wallpaperLocation")!!
                )
                result.success(
                    wallpaper
                )
            } else {
                result.notImplemented()
            }

        }
    }

    private fun setWallpaperFromFile(filePath: String, wallpaperLocation: Int): Boolean {
        val bitmap = BitmapFactory.decodeFile(filePath)
        val wm = WallpaperManager.getInstance(applicationContext)
        return try {
            if (VERSION.SDK_INT >= VERSION_CODES.N) {
                wm.setBitmap(bitmap, null, true, wallpaperLocation)
            } else {
                wm.setBitmap(bitmap)
                1
            }
            true
        } catch (e: IOException) {
            Log.e("error", e.toString())
            false
        }
    }


}
