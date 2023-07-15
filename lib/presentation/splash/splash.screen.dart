import 'package:flutter/material.dart';
import '../../generated/assets.dart';
import '../../infrastructure/base/base_view.dart';
import 'controllers/splash.controller.dart';

// ignore: use_key_in_widget_constructors
class SplashScreen extends BaseView<SplashController> {

  @override
  Widget body(BuildContext context) {
    return SafeArea(
      top: false,
      child: Center(
        child: Padding(padding: const EdgeInsets.all(60), child: FadeTransition(opacity: controller.animation, child: Image.asset(Assets.imagesIcLogo))),
      ),
    );
  }
}
