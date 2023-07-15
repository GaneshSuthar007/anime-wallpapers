import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter/cupertino.dart';
import 'widgets/heroes.dart';
import './widgets/home.dart';

import '../../infrastructure/base/base_view.dart';
import './controllers/home.controller.dart';
import '../../infrastructure/theme/colors.theme.dart';
import 'widgets/more.dart';
import 'widgets/favourite.dart';

// ignore: use_key_in_widget_constructors
class HomeScreen extends BaseView<HomeController> {
  @override
  Widget body(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: EdgeInsets.all(15.sp),
            child: Obx(() => Text(controller.labels[controller.tabIndex.value],
                style: TextStyle(
                  color: ColorsTheme.primary,
                  fontSize: 40,
                  height: 0.50,
                ))),
          ),
          Expanded(
              child: Obx(() => IndexedStack(
                    index: controller.tabIndex.value,
                    children: const [Home(), Heroes(), More()],
                  ))),
          Obx(() => controller.showAds.value!
              ? Container(
                  alignment: Alignment.center,
                  width: controller.banner.size.width.toDouble(),
                  height: controller.banner.size.height.toDouble(),
                  child: AdWidget(ad: controller.banner),
                )
              : Container())
        ],
      ),
    );
  }

  @override
  Widget bottomNavigationBar() {
    return Obx((() => BottomNavigationBar(
          unselectedItemColor: ColorsTheme.grey,
          selectedItemColor: ColorsTheme.primary,
          onTap: controller.changeTabIndex,
          currentIndex: controller.tabIndex.value,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          type: BottomNavigationBarType.fixed,
          backgroundColor: ColorsTheme.white,
          elevation: 10,
          items: [
            _bottomNavigationBarItem(
              icon: CupertinoIcons.home,
              label: controller.labels[0],
            ),
            _bottomNavigationBarItem(
              icon: CupertinoIcons.circle_grid_3x3,
              label: controller.labels[1],
            ),
            _bottomNavigationBarItem(
              icon: CupertinoIcons.settings,
              label: controller.labels[2],
            ),
          ],
        )));
  }

  _bottomNavigationBarItem({IconData? icon, String? label}) {
    return BottomNavigationBarItem(
      icon: Icon(icon),
      label: label,
    );
  }

  @override
  Future<bool> onBackPressed() async {
    if (controller.tabIndex.value != 0) {
      controller.tabIndex.value = 0;
      return false;
    }  else {
      return super.onBackPressed();
    }
  }
}
