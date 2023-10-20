package app.anime.wallpapers.di

import android.widget.ImageView
import androidx.databinding.BindingAdapter
import app.anime.wallpapers.R
import com.bumptech.glide.Glide
import com.bumptech.glide.load.engine.DiskCacheStrategy

@BindingAdapter("imageUrl")
fun setImageUrl(imageView: ImageView, imageUrl: Any?) {
    try {
        imageUrl?.let {
            Glide.with(imageView)
                .load(it)
                .placeholder(R.drawable.ic_placeholder)
                .diskCacheStrategy(DiskCacheStrategy.ALL)
                .into(imageView)
        }
    } catch (e: Exception) {
        e.printStackTrace()
    }

}
