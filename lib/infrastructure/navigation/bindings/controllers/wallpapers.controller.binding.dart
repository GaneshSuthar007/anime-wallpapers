import 'package:get/get.dart';

import '../../../../presentation/wallpapers/controllers/wallpapers.controller.dart';
import '../domains/firebase.repository.binding.dart';

class WallpapersControllerBinding extends Bindings {
  @override
  void dependencies() {
        final firebaseRepositoryBinding = FirebaseRepositoryBinding();


    Get.lazyPut<WallpapersController>(
      () => WallpapersController(firebaseRepository: firebaseRepositoryBinding.repository),
    );
  }
}
