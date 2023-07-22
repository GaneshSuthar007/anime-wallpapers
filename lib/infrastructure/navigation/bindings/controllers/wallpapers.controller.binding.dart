import 'package:get/get.dart';

import '../../../../presentation/wallpapers/controllers/wallpapers.controller.dart';
import '../domains/api.repository.binding.dart';

class WallpapersControllerBinding extends Bindings {
  @override
  void dependencies() {
    final apiRepositoryBinding = ApiRepositoryBinding();

    Get.lazyPut<WallpapersController>(
      () =>
          WallpapersController(apiRepository: apiRepositoryBinding.repository),
    );
  }
}
