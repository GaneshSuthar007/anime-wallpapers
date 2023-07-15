import 'package:get/get.dart';
import '/presentation/home/controllers/home.controller.dart';

import '/infrastructure/navigation/bindings/domains/firebase.repository.binding.dart';

class HomeControllerBinding extends Bindings {
  @override
  void dependencies() {
    final firebaseRepositoryBinding = FirebaseRepositoryBinding();

    Get.lazyPut<HomeController>(
      () => HomeController(firebaseRepository: firebaseRepositoryBinding.repository),
    );
  }
}
