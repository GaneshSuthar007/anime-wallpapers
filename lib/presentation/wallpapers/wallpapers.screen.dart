import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:sizer/sizer.dart';
import '../../generated/assets.dart';
import '../../infrastructure/base/base_view.dart';
import '../../infrastructure/base/network_image_loader.dart';
import '../../infrastructure/navigation/routes.dart';
import '../../infrastructure/theme/colors.theme.dart';
import 'controllers/wallpapers.controller.dart';

// ignore: use_key_in_widget_constructors
class WallpapersScreen extends BaseView<WallpapersController> {
  @override
  Widget body(Object context) {
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
                  child: Obx(() {
                    return Text(controller.title.value,
                        style: TextStyle(
                          color: ColorsTheme.primary,
                          fontSize: 40,
                          height: 0.50,
                        ));
                  }),
                )
              ],
            ),
          ),
          Expanded(
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                slivers: [
                  Obx(() =>
                      SliverPadding(
                        padding: EdgeInsets.symmetric(horizontal: 1.sp),
                        sliver: SliverGrid(
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 1.sp,
                              crossAxisSpacing: 1.sp,
                              childAspectRatio: (80.sp / 100.sp),
                            ),
                            delegate: SliverChildBuilderDelegate((
                                BuildContext context, int index) {
                              return Stack(
                                children: [
                                  Positioned.fill(
                                    child: InkWell(
                                      child: NetworkImageLoader(
                                        image: controller.featured.value![index]
                                            .url!,
                                      ),
                                      onTap: () {
                                        Get.toNamed(Routes.PREVIEW, arguments: {
                                          "url": controller.featured
                                              .value![index].url!,
                                        });
                                      },
                                    ),
                                  ),
                                  Positioned.fill(
                                    child: Visibility(
                                      visible:
                                      !controller.isPremium(index),
                                      child: ClipRRect(
                                        // Clip it cleanly.
                                        child: BackdropFilter(
                                          filter:
                                          ImageFilter.blur(
                                              sigmaX: 20, sigmaY: 20),
                                          child: Stack(
                                            children: [
                                              Positioned(
                                                top: 10,
                                                right: 10,
                                                child: SizedBox(
                                                  width: 40,
                                                  child: Image.asset(
                                                      Assets.imagesIconPremium),
                                                ),
                                              ),
                                              Positioned(
                                                child: Center(
                                                  child: InkWell(
                                                    child: Container(
                                                      padding:
                                                      const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 30,
                                                          vertical: 15),
                                                      decoration: BoxDecoration(
                                                        color: ColorsTheme
                                                            .primary,
                                                        borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(
                                                                100)),
                                                      ),
                                                      child: Text("Unlock",
                                                          style: TextStyle(
                                                            color: ColorsTheme
                                                                .white,
                                                            fontSize: 20,
                                                            height: 0.50,
                                                          )),
                                                    ),
                                                    onTap: () {
                                                      controller
                                                          .unlockWallpaper(
                                                          index);
                                                    },
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              );
                              // return InkWell(
                              //   onTap: () {
                              //     Get.toNamed(Routes.PREVIEW, arguments: {
                              //       "url": controller.featured.value![index].url,
                              //     });
                              //   },
                              //   child: NetworkImageLoader(
                              //     image: controller.featured.value![index].url!,
                              //   ),
                              // );
                            }, childCount: controller.featured.value!.length)),
                      ))
                ],
              )),
          Obx(() =>
          controller.showAds.value! ? Container(
            alignment: Alignment.center,
            width: controller.banner.size.width.toDouble(),
            height: controller.banner.size.height.toDouble(),
            child: AdWidget(ad: controller.banner),
          ) : Container())
        ],
      ),
    );
  }
}
