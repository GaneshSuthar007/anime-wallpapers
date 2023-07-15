import 'package:get/get.dart';

import '../../../../presentation/preview/controllers/preview.controller.dart';
import '../domains/firebase.repository.binding.dart';

class PreviewControllerBinding extends Bindings {
  @override
  void dependencies() {
    final firebaseRepositoryBinding = FirebaseRepositoryBinding();

    Get.lazyPut<PreviewController>(
      () => PreviewController(firebaseRepository: firebaseRepositoryBinding.repository),
    );
  }
}
