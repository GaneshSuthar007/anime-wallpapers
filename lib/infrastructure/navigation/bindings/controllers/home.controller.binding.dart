import 'package:get/get.dart';
import 'package:anime_wallpapers/infrastructure/navigation/bindings/domains/api.repository.binding.dart';
import '/presentation/home/controllers/home.controller.dart';

class HomeControllerBinding extends Bindings {
  @override
  void dependencies() {
    final apiRepositoryBinding = ApiRepositoryBinding();

    Get.lazyPut<HomeController>(
      () => HomeController(apiRepository: apiRepositoryBinding.repository),
    );
  }
}
