import 'package:get/get.dart';

import '../../presentation/screens.dart';
import 'bindings/controllers/controllers_bindings.dart';
import 'routes.dart';

class Nav {
  static List<GetPage> routes = [
    GetPage(
      name: Routes.home,
      page: () => HomeScreen(),
      binding: HomeControllerBinding(),
    ),
    GetPage(
      name: Routes.SPLASH,
      page: () => SplashScreen(),
      binding: SplashControllerBinding(),
    ),
    GetPage(
      name: Routes.CONTENT,
      page: () => ContentScreen(),
      binding: ContentControllerBinding(),
    ),
    GetPage(
      name: Routes.WALLPAPERS,
      page: () => WallpapersScreen(),
      binding: WallpapersControllerBinding(),
    ),
    GetPage(
      name: Routes.PREVIEW,
      page: () => PreviewScreen(),
      binding: PreviewControllerBinding(),
    ),
  ];
}
