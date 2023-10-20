import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:anime_wallpapers/domain/api/api.repository.dart';
import 'package:anime_wallpapers/infrastructure/dal/services/dto/wallpaper.response.dart';

import '../../../domain/core/constants/admob.constants.dart';
import '../../../domain/core/utils/snackbar.util.dart';
import '../../../infrastructure/base/base_controller.dart';

class WallpapersController extends BaseController {
  var title = "".obs;
  var id = 0.obs;

  final featured = Rxn<List<WallpaperResponseData>>([]);
  late RewardedInterstitialAd? _rewardeInterstitialdAd;
  final APiRepository _apiRepository;
  final unlocked = Rxn<List<int>>([]);
  WallpapersController({required APiRepository apiRepository}) : _apiRepository = apiRepository;

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
      featured.value = await _apiRepository.getWallpapers(id.value);
      for (var i = 0; i < featured.value!.length; i++) {
        if (!featured.value![i].isPremium!) {
          unlocked.value = [...unlocked.value!, i];
        }
      }
      hideLoading();
    } catch (err) {
      hideLoading();
      SnackbarUtil.showError(message: err.toString());
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
  Future<void> onConnectionChange(ConnectivityResult result) async {
    if (result == ConnectivityResult.wifi || result == ConnectivityResult.mobile) {
      try {
        showLoading();
        featured.value = await _apiRepository.getWallpapers(id.value);
        hideLoading();
      } catch (err) {
        hideLoading();
        SnackbarUtil.showError(message: err.toString());
      }
    } else if (result == ConnectivityResult.none) {
      SnackbarUtil.showError(message: "No Internet Connection. Please check your internet");
    }
  }

  bool isPremium(int index) {
    return unlocked.value!.contains(index);
  }

  void unlockWallpaper(index) async {
    showLoading();
    RewardedInterstitialAd.load(
        adUnitId: AdmobConstants.rewarded,
        request: const AdRequest(),
        rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
          onAdLoaded: (ad) {
            _rewardeInterstitialdAd = ad;
            hideLoading();
            _rewardeInterstitialdAd?.show(
              onUserEarnedReward: (ad, reward) {
                unlocked.value = [...unlocked.value!, index];
                featured.value = [...featured.value!];
              },
            );
          },
          onAdFailedToLoad: (error) {
            hideLoading();
            SnackbarUtil.showError(
                message:
                "Oops. failed to unlock premium wallpaper. try again later.");
          },
        ));
  }

  @override
  Future<void> onTokenChange(String? result) async {
    if(result != null){
      await _apiRepository.addToken(result);
    }
  }
}
