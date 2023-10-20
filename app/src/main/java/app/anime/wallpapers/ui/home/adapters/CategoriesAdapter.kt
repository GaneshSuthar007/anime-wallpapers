package app.anime.wallpapers.ui.home.adapters

import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import app.anime.wallpapers.databinding.ItemCategoriesBinding
import app.anime.wallpapers.network.data.Categories

class CategoriesAdapter(
    val onItemClick: (Int, Categories.Category) -> Unit,
    private val categories: ArrayList<Categories.Category>
) : RecyclerView.Adapter<CategoriesAdapter.WallpaperViewHolder>() {

    override fun getItemCount(): Int {
        return categories.size
    }

    inner class WallpaperViewHolder(val binding: ItemCategoriesBinding) :
        RecyclerView.ViewHolder(binding.root) {
        fun bind(position: Int) {
            binding.apply {
                item = categories[position]

                ivWallpaper.setOnClickListener {
                    onItemClick(position, categories[position])
                }
            }
        }
    }

    override fun onBindViewHolder(holder: WallpaperViewHolder, position: Int) {
        holder.bind(position)
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): WallpaperViewHolder {
        return WallpaperViewHolder(
            ItemCategoriesBinding.inflate(
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