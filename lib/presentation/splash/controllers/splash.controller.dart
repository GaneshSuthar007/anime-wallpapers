import 'dart:async';

import 'package:connectivity_plus_platform_interface/src/enums.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_app_update/in_app_update.dart';

import '../../../infrastructure/base/base_controller.dart';
import '../../../infrastructure/navigation/routes.dart';

class SplashController extends BaseController with GetTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> animation;

  @override
  void onInit() {
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )
      ..forward()
      ..addStatusListener((status) {
        update();
        checkForUpdate();
      });

    animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.ease,
    );
    super.onInit();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> checkForUpdate() async {
    InAppUpdate.checkForUpdate().then((info) {
      if (info.updateAvailability == UpdateAvailability.updateAvailable) {
        InAppUpdate.performImmediateUpdate().catchError((e) {
          switchScreen();
        });
        InAppUpdate.completeFlexibleUpdate().then((_) {
          switchScreen();
        }).catchError((e) {
          switchScreen();
        });
      } else {
        switchScreen();
      }
    }).catchError((e) {
      switchScreen();
    });
  }

  switchScreen() async {
    var duration = const Duration(seconds: 2);
    return Timer(duration, () {
      Get.offNamed(Routes.home);
    });
  }

  @override
  void onConnectionChange(ConnectivityResult result) {}

  @override
  Future<void> onTokenChange(String? result) async {}
}
