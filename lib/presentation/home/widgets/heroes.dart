import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../../infrastructure/base/network_image_loader.dart';
import '../../../infrastructure/navigation/routes.dart';
import '../../../infrastructure/theme/colors.theme.dart';
import '../controllers/home.controller.dart';

class Heroes extends GetView {
  const Heroes({super.key});

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
                      return InkWell(
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            NetworkImageLoader(
                              image: controller.heroes.value![index]['bg'],
                            ),

                            Positioned(
                              bottom: 20,
                              left: 20,
                              right: 20,
                              child: Text(controller.heroes.value![index]['name'],
                                  style: TextStyle(
                                    color: ColorsTheme.background,
                                    fontSize: 30,
                                    height: 0.80,
                                  )),
                            )
                          ],
                        ),
                        onTap: () {
                          DocumentSnapshot document = controller.heroes.value![index];
                          Get.toNamed(Routes.WALLPAPERS, arguments: {
                            "title": document.get("name"),
                            "id": document.id,
                          });
                        },
                      );
                    }, childCount: controller.heroes.value!.length)),
              ))
        ],
      );
    });
  }
}
