import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../../../infrastructure/base/network_image_loader.dart';
import '../controllers/home.controller.dart';

class Favourite extends GetView {
  const Favourite({super.key});

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
                    delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
                      return NetworkImageLoader(
                        image: controller.featured.value![index]['src'],
                      );
                    }, childCount: controller.featured.value!.length)),
              ))
        ],
      );
    });
  }
}
