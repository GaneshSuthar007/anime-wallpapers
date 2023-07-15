import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../../domain/core/constants/admob.constants.dart';
import '../../../domain/core/utils/snackbar.util.dart';
import '../../../domain/firebase/firebase.repository.dart';
import '../../../infrastructure/base/base_controller.dart';

class WallpapersController extends BaseController {
  var title = "".obs;
  var id = "".obs;

  final featured = Rxn<List<DocumentSnapshot>>([]);

  final FirebaseRepository _firebaseRepository;

  WallpapersController({required FirebaseRepository firebaseRepository}) : _firebaseRepository = firebaseRepository;

  var showAds = Rxn<bool>(false);
  late BannerAd banner;
  late BannerAdListener listener;

  @override
  void onInit() async {
    initAds();
    var data = Get.arguments;
    title.value = data['title'];
    id.value = data['id'];
    try {
      showLoading();
      featured.value = await _firebaseRepository.getWallpaperByHero(id.value);
      hideLoading();
    } catch (err) {
      hideLoading();
      SnackbarUtil.showError(message: err.toString());
    }
    super.onInit();
  }

  void initAds() {
    MobileAds.instance.updateRequestConfiguration(RequestConfiguration(testDeviceIds: ['9078A869DA39F95D4CEF14A600401F01']));
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
  Future<void> onConnectionChange(ConnectivityResult result) async {
    if (result == ConnectivityResult.wifi || result == ConnectivityResult.mobile) {
      try {
        showLoading();
        featured.value = await _firebaseRepository.getWallpaperByHero(id.value);
        hideLoading();
      } catch (err) {
        hideLoading();
        SnackbarUtil.showError(message: err.toString());
      }
    } else if (result == ConnectivityResult.none) {
      SnackbarUtil.showError(message: "No Internet Connection. Please check your internet");
    }
  }

  @override
  Future<void> onTokenChange(String? result) async {
    if(result != null){
      await _firebaseRepository.saveFCMToken(result);
    }
  }
}
