import 'package:async_wallpaper/async_wallpaper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:mailto/mailto.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../domain/core/constants/admob.constants.dart';
import '../../../domain/core/utils/snackbar.util.dart';
import '../../../domain/firebase/firebase.repository.dart';
import '../../../infrastructure/base/base_controller.dart';

class PreviewController extends BaseController {
  final wallpaper = Rxn<DocumentSnapshot?>();
  final time = Rxn<String>("");
  final date = Rxn<String>("");
  final FirebaseRepository _firebaseRepository;

  PreviewController({required FirebaseRepository firebaseRepository})
      : _firebaseRepository = firebaseRepository;

  var showAds = Rxn<bool>(false);
  var showFullScreenAds = Rxn<bool>(false);
  late BannerAd banner;
  late BannerAdListener listener;
  late InterstitialAd interstitialAd;

  @override
  void onInit() async {
    initAds();
    DateTime now = DateTime.now();
    time.value = DateFormat('HH:mm').format(now);
    date.value = DateFormat('EEE d MMM').format(now);

    var data = Get.arguments;
    try {
      showLoading();
      wallpaper.value = await _firebaseRepository.getWallpaper(data['id']);
      hideLoading();
    } catch (err) {
      hideLoading();
      SnackbarUtil.showError(message: err.toString());
    }
    super.onInit();
  }

  void applyHomeScreen(url) async {
    try {
      showLoading();
      var result = await AsyncWallpaper.setWallpaper(
          url: url, wallpaperLocation: AsyncWallpaper.HOME_SCREEN);
      hideLoading();
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
      showLoading();
      var result = await AsyncWallpaper.setWallpaper(
          url: url, wallpaperLocation: AsyncWallpaper.LOCK_SCREEN);
      hideLoading();
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
    // final Uri url = Uri(scheme: 'mailto', path: 'starpremiumappz@gmail.com', query: 'subject=Report Wallpaper &body=Wallpaper ID $id');
    // if (await canLaunchUrl(url)) {
    //   await launchUrl(url);
    // }
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
    MobileAds.instance.updateRequestConfiguration(RequestConfiguration(testDeviceIds: ['9078A869DA39F95D4CEF14A600401F01']));
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
            interstitialAd.fullScreenContentCallback = FullScreenContentCallback(
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
  Future<void> onConnectionChange(ConnectivityResult result) async {
    if (result == ConnectivityResult.wifi ||
        result == ConnectivityResult.mobile) {
      var data = Get.arguments;
      try {
        showLoading();
        wallpaper.value = await _firebaseRepository.getWallpaper(data['id']);
        hideLoading();
      } catch (err) {
        hideLoading();
        SnackbarUtil.showError(message: err.toString());
      }
    } else if (result == ConnectivityResult.none) {
      SnackbarUtil.showError(
          message: "No Internet Connection. Please check your internet");
    }
  }

  @override
  Future<void> onTokenChange(String? result) async {
    if (result != null) {
      await _firebaseRepository.saveFCMToken(result);
    }
  }
}
