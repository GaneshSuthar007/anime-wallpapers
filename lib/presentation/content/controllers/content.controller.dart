import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../../domain/core/constants/admob.constants.dart';
import '../../../infrastructure/base/base_controller.dart';

class ContentController extends BaseController {
  var title = "".obs;
  var description = "".obs;

  var showAds =  Rxn<bool>(false);
  late BannerAd banner;
  late BannerAdListener listener;

  @override
  void onInit() {
    initAds();
    var data = Get.arguments;
    title.value = data['title'];
    if (title.value == "How to set wallpaper.?") {
      description.value = 'Step 1. On the Home screen, touch and hold an empty space.\nStep 2. Tap Wallpapers.\nStep 3. Select a category to find wallpaper options.\nStep 4. Select an image.\nStep 5. Tap Set Wallpaper.\nStep 6. Choose where you want to see this wallpaper.';
    }else if (title.value == "Disclaimer") {
      description.value = "All the wallpapers in this app are under common creative license and the credit goes to their respective owners. These images are not endorsed by any of the prospective owners, and the images are used simply for aesthetic purposes. No copyright infringement is intended, and any request to remove one of the images/logos/names will be honored.";
    }

    super.onInit();
  }

  void initAds() {
    MobileAds.instance.updateRequestConfiguration(RequestConfiguration(testDeviceIds: ['4B2C5CE05599DDA161AE9A55E73554F0']));
    listener = BannerAdListener(
        onAdLoaded: (Ad ad) => showAds.value = true,
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          debugPrint(error.message);
          ad.dispose();
          showAds.value = false;
        }
    );
    banner = BannerAd(
      adUnitId: AdmobConstants.bannerAd,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: listener,
    )..load();
  }

  @override
  void onConnectionChange(ConnectivityResult result) {}

  @override
  Future<void> onTokenChange(String? result) async {}
}
