import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:sizer/sizer.dart';

import '../../../infrastructure/base/network_image_loader.dart';
import '../../../infrastructure/navigation/routes.dart';
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
                    delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
                      return Stack(
                        children: [
                          Positioned.fill(
                            child: InkWell(
                              child: NetworkImageLoader(
                                image: controller.featured.value![index]['src'],
                              ),
                              onTap: () {
                                DocumentSnapshot document = controller.featured.value![index];
                                Get.toNamed(Routes.PREVIEW, arguments: {
                                  "id": document.id,
                                });
                              },
                            ),
                          ),
                          // Positioned(
                          //   top: 15,
                          //   right: 15,
                          //   child: InkWell(
                          //     onTap: () {
                          //       DocumentSnapshot document = controller.featured.value![index];
                          //       controller.makeFavourite(document.id);
                          //     },
                          //     child: Icon(
                          //       CupertinoIcons.heart_circle,
                          //       size: 25.sp,
                          //     ),
                          //   ),
                          // )
                        ],
                      );
                    }, childCount: controller.featured.value!.length)),
              ))
        ],
      );
    });
  }
}
