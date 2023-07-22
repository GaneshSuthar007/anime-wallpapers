import 'package:anime_wallpapers/domain/core/constants/admob.constants.dart';
import 'package:anime_wallpapers/infrastructure/dal/services/dto/categories.response.dart';
import 'package:anime_wallpapers/infrastructure/dal/services/dto/wallpaper.response.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:mailto/mailto.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:store_redirect/store_redirect.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../domain/api/api.repository.dart';
import '../../../domain/core/utils/snackbar.util.dart';
import '../../../infrastructure/base/base_controller.dart';

class HomeController extends BaseController {
  final APiRepository _apiRepository;
  var tabIndex = 0.obs;
  var reviewAvailable = false;

  HomeController({required APiRepository apiRepository})
      : _apiRepository = apiRepository;
  final categories = Rxn<List<CategoriesResponseData>>([]);
  final featured = Rxn<List<WallpaperResponseData>>([]);
  final unlocked = Rxn<List<int>>([]);
  List<String> labels = ["Anime Wallpapers", "Characters", "More"];

  var showAds = Rxn<bool>(false);
  var showRating = Rxn<bool>(true);
  late BannerAd banner;
  late BannerAdListener listener;
  final InAppReview inAppReview = InAppReview.instance;
  late RewardedInterstitialAd? _rewardeInterstitialdAd;

  @override
  void onInit() async {
    initAds();
    try {
      showLoading();
      reviewAvailable = await inAppReview.isAvailable();
      categories.value = await _apiRepository.getCategories();
      featured.value = await _apiRepository.getWallpapers();
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

  void changeTabIndex(int index) {
    tabIndex.value = index;
  }

  void sendFeedback() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    // final Uri url = Uri(scheme: 'mailto', path: 'starpremiumappz@gmail.com', query: 'subject=App Feedback&body=App Version ${packageInfo.version} - ${packageInfo.buildNumber}');
    // if (await canLaunchUrl(url)) {
    //   await launchUrl(url);
    // }
    try {
      final mailtoLink = Mailto(
        to: ['starpremiumappz@gmail.com'],
        subject: 'App Feedback',
        body:
            '\nDo Not Remove this \n App Version ${packageInfo.version} - ${packageInfo.buildNumber}',
      );
      await launchUrl(Uri.parse('$mailtoLink'));
    } on Exception {
      SnackbarUtil.showError(
          message: "Oops. failed to launch mail. try again later.");
    }
  }

  void about() async {
    StoreRedirect.redirect(androidAppId: "app.anime.wallpapers");
  }

  void share() async {}

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
    banner = BannerAd(
      adUnitId: AdmobConstants.bannerAd,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: listener,
    )..load();
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
            print(error);
            SnackbarUtil.showError(
                message:
                    "Oops. failed to unlock premium wallpaper. try again later.");
          },
        ));
  }

  @override
  Future<void> onConnectionChange(ConnectivityResult result) async {
    if (result == ConnectivityResult.wifi ||
        result == ConnectivityResult.mobile) {
      try {
        showLoading();
        categories.value = await _apiRepository.getCategories();
        featured.value = await _apiRepository.getWallpapers();
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
      await _apiRepository.addToken(result);
    }
  }
}
