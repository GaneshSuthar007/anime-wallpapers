import 'package:get/get.dart';

import '../../../../presentation/content/controllers/content.controller.dart';

class ContentControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ContentController>(
      () => ContentController(),
    );
  }
}
