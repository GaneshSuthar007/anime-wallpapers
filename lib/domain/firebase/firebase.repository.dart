import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../infrastructure/dal/services/firebase/firebase.service.dart';

class FirebaseRepository {
  final FirebaseService _firebaseService;
  final _storage = Get.find<GetStorage>();

  FirebaseRepository({
    required FirebaseService firebaseService,
  }) : _firebaseService = firebaseService;

  Future<List<DocumentSnapshot>> getHeroes() async {
    try {
      return await _firebaseService.getHeroes();
    } catch (err) {
      rethrow;
    }
  }

  Future<List<DocumentSnapshot>> getFeatured() async {
    try {
      return await _firebaseService.getFeatured();
    } catch (err) {
      rethrow;
    }
  }

  Future<DocumentSnapshot> getWallpaper(String id) async {
    try {
      return await _firebaseService.getWallpaper(id);
    } catch (err) {
      rethrow;
    }
  }

  Future<List<DocumentSnapshot>> getWallpaperByHero(String heroId) async {
    try {
      return await _firebaseService.getWallpaperByHero(heroId);
    } catch (err) {
      rethrow;
    }
  }

  Future<void> makeFavourite(String wallpaperId) async {
    try {
      var deviceInfo = DeviceInfoPlugin();
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return await _firebaseService.makeFavourite(androidDeviceInfo.id,wallpaperId);
    } catch (err) {
      rethrow;
    }
  }
  Future<void> saveFCMToken(String token) async {
    try {
      return await _firebaseService.saveFCMToken(token);
    } catch (err) {
      rethrow;
    }
  }


}
