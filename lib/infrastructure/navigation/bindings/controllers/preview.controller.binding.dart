import 'package:get/get.dart';
import 'package:anime_wallpapers/infrastructure/navigation/bindings/domains/api.repository.binding.dart';

import '../../../../presentation/preview/controllers/preview.controller.dart';

class PreviewControllerBinding extends Bindings {
  @override
  void dependencies() {
    final apiRepositoryBinding = ApiRepositoryBinding();

    Get.lazyPut<PreviewController>(
      () => PreviewController(apiRepository: apiRepositoryBinding.repository),
    );
  }
}
