package app.anime.wallpapers.ui.home.adapters

import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import app.anime.wallpapers.databinding.ItemWallpapersBinding
import app.anime.wallpapers.network.data.Wallpapers

class WallpapersAdapter(
    val onItemClick: (Int, Wallpapers.Data) -> Unit,
    private val wallpapers: ArrayList<Wallpapers.Data>
) : RecyclerView.Adapter<WallpapersAdapter.WallpaperViewHolder>() {

    override fun getItemCount(): Int {
        return wallpapers.size
    }

    inner class WallpaperViewHolder(val binding: ItemWallpapersBinding) :
        RecyclerView.ViewHolder(binding.root) {
        fun bind(position: Int) {
            binding.apply {
                item = wallpapers[position]
                ivWallpaper.setOnClickListener {
                    onItemClick(position, wallpapers[position])
                }
                if (wallpapers[position].isPremium){
                    vLock.visibility = View.VISIBLE
                    rlLock.visibility = View.VISIBLE
                }else{
                    vLock.visibility = View.GONE
                    rlLock.visibility = View.GONE
                }
            }
        }
    }

    override fun onBindViewHolder(holder: WallpaperViewHolder, position: Int) {
        holder.bind(position)
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): WallpaperViewHolder {
        return WallpaperViewHolder(
            ItemWallpapersBinding.inflate(
                LayoutInflater.from(parent.context),
                parent,
                false
            )
        )
    }

    override fun getItemViewType(position: Int): Int {
        return position
    }

}