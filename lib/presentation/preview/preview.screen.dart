import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:sizer/sizer.dart';

import '../../infrastructure/base/base_view.dart';
import '../../infrastructure/base/network_image_loader.dart';
import '../../infrastructure/theme/colors.theme.dart';
import 'controllers/preview.controller.dart';

// ignore: use_key_in_widget_constructors
class PreviewScreen extends BaseView<PreviewController> {
  @override
  Widget body(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          SizedBox(
            height: 42.sp,
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  bottom: 0,
                  child: Padding(
                    padding: EdgeInsets.all(10.sp),
                    child: InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: Icon(
                        CupertinoIcons.chevron_back,
                        color: ColorsTheme.primary,
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Text("Preview",
                      style: TextStyle(
                        color: ColorsTheme.primary,
                        fontSize: 40,
                        height: 0.50,
                      )),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10.sp),
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 250.sp,
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15.sp),
                            child: Obx(() {
                              return controller.wallpaper.value != null ? NetworkImageLoader(
                                image: controller.wallpaper.value!['src'],
                              ):Container();
                            }),
                          ),
                        ),
                        Positioned(
                          left: 5,
                          right: 5,
                          top: 50,
                          child: Column(
                            children: [
                              Obx(() => Text(controller.time.value!,
                                  style: TextStyle(
                                    color: ColorsTheme.white,
                                    fontSize: 40,
                                    height: 0.50,
                                  ))),
                              SizedBox(
                                height: 10.sp,
                              ),
                              Obx(() => Text(controller.date.value!,
                                  style: TextStyle(
                                    color: ColorsTheme.white,
                                    fontSize: 20,
                                    height: 0.50,
                                  ))),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 10.sp),
                Expanded(
                  child: SizedBox(
                    height: 250.sp,
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15.sp),
                            child: Obx(() {
                              return controller.wallpaper.value != null ? NetworkImageLoader(
                                image: controller.wallpaper.value!['src'],
                              ):Container();
                            }),
                          ),
                        ),
                        Positioned(
                          left: 5,
                          right: 5,
                          bottom: 10,
                          child: Column(
                            children: [
                              SizedBox(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.sp), color: Colors.grey.shade50.withOpacity(0.5)),
                                      width: 30.sp,
                                      height: 30.sp,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.sp), color: Colors.grey.shade50.withOpacity(0.5)),
                                      width: 30.sp,
                                      height: 30.sp,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.sp), color: Colors.grey.shade50.withOpacity(0.5)),
                                      width: 30.sp,
                                      height: 30.sp,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.sp), color: Colors.grey.shade50.withOpacity(0.5)),
                                      width: 30.sp,
                                      height: 30.sp,
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10.sp,
                              ),
                              SizedBox(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.sp), color: Colors.grey.shade50.withOpacity(0.5)),
                                      width: 30.sp,
                                      height: 30.sp,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.sp), color: Colors.grey.shade50.withOpacity(0.5)),
                                      width: 30.sp,
                                      height: 30.sp,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.sp), color: Colors.grey.shade50.withOpacity(0.5)),
                                      width: 30.sp,
                                      height: 30.sp,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.sp), color: Colors.grey.shade50.withOpacity(0.5)),
                                      width: 30.sp,
                                      height: 30.sp,
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 16.sp,
          ),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                children: [
                  InkWell(
                    onTap: (){
                      controller.applyLockScreen(controller.wallpaper.value!['src']);
                    },
                    child: Container(
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(14.sp), color: ColorsTheme.primary),
                      width: 50.sp,
                      height: 50.sp,
                      child: const Icon(CupertinoIcons.lock),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      controller.applyHomeScreen(controller.wallpaper.value!['src']);
                    },
                    child: Container(
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(14.sp), color: ColorsTheme.primary),
                      width: 50.sp,
                      height: 50.sp,
                      child: const Icon(CupertinoIcons.home),
                    ),
                  ),
                  // Container(
                  //   decoration: BoxDecoration(borderRadius: BorderRadius.circular(14.sp), color: ColorsTheme.primary),
                  //   width: 50.sp,
                  //   height: 50.sp,
                  //   child: const Icon(CupertinoIcons.heart),
                  // ),
                  InkWell(
                    onTap: (){
                      DocumentSnapshot document = controller.wallpaper.value!;
                      controller.sendReport(document.id);
                    },
                    child: Container(
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(14.sp), color: ColorsTheme.primary),
                      width: 50.sp,
                      height: 50.sp,
                      child: const Icon(CupertinoIcons.exclamationmark),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 40.sp,
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
