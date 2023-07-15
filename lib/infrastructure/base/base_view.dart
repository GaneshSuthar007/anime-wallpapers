// ignore_for_file: use_key_in_widget_constructors

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:superheroes_wallpapers/infrastructure/theme/colors.theme.dart';
import 'base_controller.dart';
import 'loading.dart';
import 'page_state.dart';

abstract class BaseView<Controller extends BaseController> extends GetView<Controller> {
  final GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();

  Widget body(BuildContext context);

  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer =
  FirebaseAnalyticsObserver(analytics: analytics);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Stack(
        children: [
          annotatedRegion(context),
          Obx(() => controller.pageState == PageState.LOADING ? _showLoading() : Container()),
        ],
      ),
      onWillPop: () async {
        return await onBackPressed();
      },
    );
  }

  Widget annotatedRegion(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: statusBarColor(),
        statusBarIconBrightness: statusBarBrightness(),
        statusBarBrightness: statusBarBrightness(),
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark
      ),
      child: Material(
        color: Colors.transparent,
        child: pageScaffold(context),
      ),
    );
  }

  Brightness statusBarBrightness() => Brightness.dark;

  Widget pageScaffold(BuildContext context) {
    return Scaffold(
      backgroundColor: pageBackgroundColor(),
      key: globalKey,
      body: body(context),
      bottomNavigationBar: bottomNavigationBar(),
    );
  }

  Widget showErrorSnackBar(String message) {
    final snackBar = SnackBar(content: Text(message));
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ScaffoldMessenger.of(Get.context!).showSnackBar(snackBar);
    });

    return Container();
  }

  void showToast(String message) {}

  Color pageBackgroundColor() => ColorsTheme.background;

  Color statusBarColor() => Colors.transparent;

  Widget? bottomNavigationBar() {
    return null;
  }

  Future<bool> onBackPressed() async {
    return true;
  }

  Widget _showLoading() {
    return const Loading();
  }
}
