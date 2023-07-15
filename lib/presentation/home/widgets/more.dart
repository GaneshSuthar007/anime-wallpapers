import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../../../infrastructure/navigation/routes.dart';
import '../../../infrastructure/theme/colors.theme.dart';
import '../controllers/home.controller.dart';

class More extends GetView {
  const More({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(builder: (controller) {
      return CustomScrollView(
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        slivers: [
          SliverToBoxAdapter(
            child: InkWell(
              onTap: () {
                Get.toNamed(Routes.CONTENT, arguments: {"title": "How to set wallpaper.?"});
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 8.sp),
                child: Row(
                  children: [
                    Icon(CupertinoIcons.settings, color: ColorsTheme.primary),
                    SizedBox(
                      width: 12.sp,
                    ),
                    Text("How to set wallpaper.?",
                        style: TextStyle(
                          color: ColorsTheme.primary,
                          fontSize: 20,
                          fontWeight: FontWeight.w300,
                          height: 0.50,
                        ))
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: InkWell(
              onTap: () {
                controller.share();
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 8.sp),
                child: Row(
                  children: [
                    Icon(CupertinoIcons.share, color: ColorsTheme.primary),
                    SizedBox(
                      width: 12.sp,
                    ),
                    Text("Tell a friend",
                        style: TextStyle(
                          color: ColorsTheme.primary,
                          fontSize: 20,
                          fontWeight: FontWeight.w300,
                          height: 0.50,
                        ))
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: InkWell(
              onTap: () {
                controller.sendFeedback();
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 8.sp),
                child: Row(
                  children: [
                    Icon(CupertinoIcons.exclamationmark_bubble, color: ColorsTheme.primary),
                    SizedBox(
                      width: 12.sp,
                    ),
                    Text("Feedback",
                        style: TextStyle(
                          color: ColorsTheme.primary,
                          fontSize: 20,
                          fontWeight: FontWeight.w300,
                          height: 0.50,
                        ))
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: InkWell(
              onTap: () {
                Get.toNamed(Routes.CONTENT, arguments: {"title": "Disclaimer"});
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 8.sp),
                child: Row(
                  children: [
                    Icon(CupertinoIcons.settings, color: ColorsTheme.primary),
                    SizedBox(
                      width: 12.sp,
                    ),
                    Text("Disclaimer",
                        style: TextStyle(
                          color: ColorsTheme.primary,
                          fontSize: 20,
                          fontWeight: FontWeight.w300,
                          height: 0.50,
                        ))
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Visibility(
              visible: controller.reviewAvailable,
              child: InkWell(
                onTap: () async {
                  if (controller.reviewAvailable) controller.inAppReview.requestReview();
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 8.sp),
                  child: Row(
                    children: [
                      Icon(CupertinoIcons.star, color: ColorsTheme.primary),
                      SizedBox(
                        width: 12.sp,
                      ),
                      Text("Rate-Us",
                          style: TextStyle(
                            color: ColorsTheme.primary,
                            fontSize: 20,
                            fontWeight: FontWeight.w300,
                            height: 0.50,
                          ))
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: InkWell(
              onTap: () {
                controller.about();
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 8.sp),
                child: Row(
                  children: [
                    Icon(CupertinoIcons.info, color: ColorsTheme.primary),
                    SizedBox(
                      width: 12.sp,
                    ),
                    Text("About Us",
                        style: TextStyle(
                          color: ColorsTheme.primary,
                          fontSize: 20,
                          fontWeight: FontWeight.w300,
                          height: 0.50,
                        ))
                  ],
                ),
              ),
            ),
          )
        ],
      );
    });
  }
}
