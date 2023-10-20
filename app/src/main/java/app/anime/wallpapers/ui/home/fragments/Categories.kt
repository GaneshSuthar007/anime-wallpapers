package app.anime.wallpapers.ui.home.fragments

import android.os.Bundle
import android.view.View
import androidx.recyclerview.widget.GridLayoutManager
import app.anime.wallpapers.core.BaseFragment
import app.anime.wallpapers.databinding.FragmentCategoriesBinding
import app.anime.wallpapers.ui.home.HomeActivity
import app.anime.wallpapers.ui.home.VHHome
import app.anime.wallpapers.ui.home.adapters.CategoriesAdapter
import app.anime.wallpapers.ui.wallpapers.WallpapersActivity
import app.anime.wallpapers.utils.extensions.openActivity

class Categories : BaseFragment<VHHome, FragmentCategoriesBinding>() {
    override fun getViewBinding() = FragmentCategoriesBinding.inflate(layoutInflater)

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        getCategories()
        val layoutManager = GridLayoutManager(requireActivity(), 2)
        binding.rvCategories.layoutManager = layoutManager
    }

    private fun getCategories() {
        viewModel.getCategories(
            hashMapOf<String, Any>(
                "app_id" to 1,
            )
        ).observe(viewLifecycleOwner) {
            wsWithLoader(it) {
                it.data?.let { it ->
                    it.data?.let { data ->
                        val adapter = CategoriesAdapter({ _, category ->
                            requireActivity().openActivity<WallpapersActivity>(
                                "category_id" to category.id,
                                "category_name" to category.name
                            )
                        }, data.categories)
                        binding.rvCategories.adapter = adapter
                    }
                }
            }
        }
    }
}