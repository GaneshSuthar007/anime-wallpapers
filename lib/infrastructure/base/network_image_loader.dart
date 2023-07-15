import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class NetworkImageLoader extends StatelessWidget {
  const NetworkImageLoader({Key? key, required this.image}) : super(key: key);
  final String image;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: image,
      fit: BoxFit.cover,
      placeholder: (context, url) => Center(
        child: SizedBox(
          width: 20.sp,
          height: 20.sp,
          child: const CircularProgressIndicator(),
        ),
      ),
    );
  }
}
