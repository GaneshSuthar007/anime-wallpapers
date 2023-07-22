import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../../generated/assets.dart';
import '../../../infrastructure/base/network_image_loader.dart';
import '../../../infrastructure/navigation/routes.dart';
import '../../../infrastructure/theme/colors.theme.dart';
import '../controllers/home.controller.dart';

class Home extends GetView {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(builder: (controller) {
      return CustomScrollView(
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        slivers: [
          Obx(() => SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 1.sp),
                sliver: SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 1.sp,
                      crossAxisSpacing: 1.sp,
                      childAspectRatio: (80.sp / 100.sp),
                    ),
                    delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                      return Stack(
                        children: [
                          Positioned.fill(
                            child: InkWell(
                              child: NetworkImageLoader(
                                image: controller.featured.value![index].url!,
                              ),
                              onTap: () {
                                Get.toNamed(Routes.PREVIEW, arguments: {
                                  "url": controller.featured.value![index].url!,
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
                                      ImageFilter.blur(sigmaX: 20, sigmaY: 20),
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
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 30,
                                                      vertical: 15),
                                              decoration: BoxDecoration(
                                                color: ColorsTheme.primary,
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(100)),
                                              ),
                                              child: Text("Unlock",
                                                  style: TextStyle(
                                                    color: ColorsTheme.white,
                                                    fontSize: 20,
                                                    height: 0.50,
                                                  )),
                                            ),
                                            onTap: () {
                                              controller.unlockWallpaper(index);
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
                    }, childCount: controller.featured.value!.length)),
              ))
        ],
      );
    });
  }
}
