import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:sizer/sizer.dart';

import '../../infrastructure/base/base_view.dart';
import '../../infrastructure/theme/colors.theme.dart';
import 'controllers/content.controller.dart';

// ignore: use_key_in_widget_constructors
class ContentScreen extends BaseView<ContentController> {
  @override
  Widget body(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          InkWell(
            onTap: () {
              Get.back();
            },
            child: Padding(
              padding: EdgeInsets.all(15.sp),
              child: Icon(
                CupertinoIcons.chevron_back,
                color: ColorsTheme.primary,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.sp),
            child: Obx(() => Text(controller.title.value,
                style: TextStyle(
                  color: ColorsTheme.primary,
                  fontSize: 40,
                  height: 0.50,
                ))),
          ),
          SizedBox(
            height: 15.sp,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.sp),
                child: Obx(() => Text(controller.description.value,
                    style: TextStyle(
                      color: ColorsTheme.primary,
                      fontSize: 20,
                      height: 0.90,
                    ))),
              ),
            ),
          ),
          Obx(() => controller.showAds.value! ? Container(
            alignment: Alignment.center,
            width: controller.banner.size.width.toDouble(),
            height: controller.banner.size.height.toDouble(),
            child: AdWidget(ad: controller.banner),
          ):Container())
        ],
      ),
    );
  }
}
