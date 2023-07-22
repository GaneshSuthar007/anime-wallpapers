import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_wallpaper_manager/flutter_wallpaper_manager.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:mailto/mailto.dart';
import 'package:anime_wallpapers/domain/api/api.repository.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../domain/core/constants/admob.constants.dart';
import '../../../domain/core/utils/snackbar.util.dart';
import '../../../infrastructure/base/base_controller.dart';

class PreviewController extends BaseController {
  final time = Rxn<String>("");
  final date = Rxn<String>("");
  final url = Rxn<String>("");
  final APiRepository _apiRepository;

  PreviewController({required APiRepository apiRepository})
      : _apiRepository = apiRepository;

  var showAds = Rxn<bool>(false);
  var showFullScreenAds = Rxn<bool>(false);
  late BannerAd banner;
  late BannerAdListener listener;
  late InterstitialAd interstitialAd;

  @override
  void onInit() async {
    super.onInit();
    initAds();
    DateTime now = DateTime.now();
    time.value = DateFormat('HH:mm').format(now);
    date.value = DateFormat('EEE d MMM').format(now);
    url.value = Get.arguments['url'];
  }

  void applyHomeScreen(url) async {
    try {
      int location = WallpaperManager.HOME_SCREEN;
      var file = await DefaultCacheManager().getSingleFile(url);
      final bool result =
          await WallpaperManager.setWallpaperFromFile(file.path, location);
      if (result) {
        SnackbarUtil.showSuccess(
            title: "Wallpaper applied.", message: "it looks awesome :) ");
        if (showFullScreenAds.value!) {
          interstitialAd.show();
        }
      } else {
        SnackbarUtil.showError(
            message: "Oops. something went wrong. try again later.");
      }
    } on PlatformException {
      SnackbarUtil.showError(
          message: "Oops. something went wrong. try again later.");
    }
  }

  void applyLockScreen(url) async {
    try {
      int location = WallpaperManager.LOCK_SCREEN;
      var file = await DefaultCacheManager().getSingleFile(url);
      final bool result =
      await WallpaperManager.setWallpaperFromFile(file.path, location);
      if (result) {
        SnackbarUtil.showSuccess(
            title: "Wallpaper applied.", message: "it looks awesome :) ");
        if (showFullScreenAds.value!) {
          interstitialAd.show();
        }
      } else {
        SnackbarUtil.showError(
            message: "Oops. something went wrong. try again later.");
      }
    } on PlatformException {
      SnackbarUtil.showError(
          message: "Oops. something went wrong. try again later.");
    }
  }

  void sendReport(id) async {
    try {
      final mailtoLink = Mailto(
        to: ['starpremiumappz@gmail.com'],
        subject: 'Report Wallpaper',
        body: '\nDo Not Remove this \nWallpaper ID $id',
      );
      await launchUrl(Uri.parse('$mailtoLink'));
    } on Exception {
      SnackbarUtil.showError(
          message: "Oops. failed to launch mail. try again later.");
    }
  }

  void initAds() {
    MobileAds.instance.updateRequestConfiguration(RequestConfiguration(
        testDeviceIds: ['9078A869DA39F95D4CEF14A600401F01']));
    listener = BannerAdListener(
        onAdLoaded: (Ad ad) => showAds.value = true,
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          debugPrint(error.message);
          ad.dispose();
          showAds.value = false;
        });

    InterstitialAd.load(
        adUnitId: AdmobConstants.fullScreenAd,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            showFullScreenAds.value = true;
            interstitialAd = ad;
            interstitialAd.fullScreenContentCallback =
                FullScreenContentCallback(
              onAdDismissedFullScreenContent: (InterstitialAd ad) {
                ad.dispose();
                showFullScreenAds.value = false;
              },
            );
          },
          onAdFailedToLoad: (LoadAdError error) {
            debugPrint(error.message);
          },
        ));

    banner = BannerAd(
      adUnitId: AdmobConstants.bannerAd,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: listener,
    )..load();
  }

  @override
  Future<void> onConnectionChange(ConnectivityResult result) async {}

  @override
  Future<void> onTokenChange(String? result) async {
    if (result != null) {
      await _apiRepository.addToken(result);
    }
  }
}
