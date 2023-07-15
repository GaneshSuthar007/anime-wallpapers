import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:mailto/mailto.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:store_redirect/store_redirect.dart';
import 'package:superheroes_wallpapers/domain/core/constants/admob.constants.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../domain/core/utils/snackbar.util.dart';
import '../../../domain/firebase/firebase.repository.dart';
import '../../../infrastructure/base/app_lifecycle_reactor.dart';
import '../../../infrastructure/base/base_controller.dart';

class HomeController extends BaseController {
  final FirebaseRepository _firebaseRepository;
  var tabIndex = 0.obs;
  var reviewAvailable = false;
  HomeController({required FirebaseRepository firebaseRepository}) : _firebaseRepository = firebaseRepository;
  final heroes = Rxn<List<DocumentSnapshot>>([]);
  final featured = Rxn<List<DocumentSnapshot>>([]);
  List<String> labels = ["Super Heroes", "Heroes", "More"];

  var showAds = Rxn<bool>(false);
  var showRating = Rxn<bool>(true);
  late BannerAd banner;
  late BannerAdListener listener;
  final InAppReview inAppReview = InAppReview.instance;

  @override
  void onInit() async {
    initAds();
    try {
      showLoading();
      reviewAvailable = await inAppReview.isAvailable();
      heroes.value = await _firebaseRepository.getHeroes();
      featured.value = await _firebaseRepository.getFeatured();
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
        body: '\nDo Not Remove this \n App Version ${packageInfo.version} - ${packageInfo.buildNumber}',
      );
      await launchUrl(Uri.parse('$mailtoLink'));
    } on Exception {
      SnackbarUtil.showError(
          message: "Oops. failed to launch mail. try again later.");
    }
  }

  void about() async {
    StoreRedirect.redirect(androidAppId: "app.superheroes_wallpapers");
  }

  void share() async {}

  void makeFavourite(String wallpaperId) async {
    showLoading();
    await _firebaseRepository.makeFavourite(wallpaperId);
    hideLoading();
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
    banner = BannerAd(
      adUnitId: AdmobConstants.bannerAd,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: listener,
    )..load();
  }
  @override
  Future<void> onConnectionChange(ConnectivityResult result) async {
      if(result == ConnectivityResult.wifi || result == ConnectivityResult.mobile){
        try {
          showLoading();
          heroes.value = await _firebaseRepository.getHeroes();
          featured.value = await _firebaseRepository.getFeatured();
          hideLoading();
        } catch (err) {
          hideLoading();
          SnackbarUtil.showError(message: err.toString());
        }
      }else if(result == ConnectivityResult.none){
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
