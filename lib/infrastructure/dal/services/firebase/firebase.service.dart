import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';

class FirebaseService {
  final FirebaseFirestore _instance;

  const FirebaseService(FirebaseFirestore instance) : _instance = instance;

  Future<List<DocumentSnapshot>> getHeroes() async {
    try {
      if (await isInternet()) {
        QuerySnapshot querySnapshot = await _instance.collection("heroes").orderBy('order').get();
        return querySnapshot.docs;
      } else {
        throw Exception("No Internet Connection. Please check your internet");
      }
    } on FirebaseException catch (e) {
      throw e.message ?? 'Something went wrong';
    }
  }

  Future<List<DocumentSnapshot>> getFeatured() async {
    try {
      if (await isInternet()) {
        QuerySnapshot querySnapshot = await _instance.collection("wallpapers").limit(100).get();
        return querySnapshot.docs;
      } else {
        throw Exception("No Internet Connection. Please check your internet");
      }
    } on FirebaseException catch (e) {
      throw e.message ?? 'Something went wrong';
    }
  }

  Future<DocumentSnapshot> getWallpaper(String id) async {
    try {
      if (await isInternet()) {
        return await _instance.collection("wallpapers").doc(id).get();
      } else {
        throw Exception("No Internet Connection. Please check your internet");
      }
    } on FirebaseException catch (e) {
      throw e.message ?? 'Something went wrong';
    }
  }

  Future<List<DocumentSnapshot>> getWallpaperByHero(String heroId) async {
    try {
      if (await isInternet()) {
        DocumentSnapshot hero = await _instance.collection("heroes").doc(heroId).get();
        QuerySnapshot querySnapshot = await _instance.collection("wallpapers").where('hero_id', isEqualTo: hero.reference).get();
        return querySnapshot.docs;
      } else {
        throw Exception("No Internet Connection. Please check your internet");
      }
    } on FirebaseException catch (e) {
      throw e.message ?? 'Something went wrong';
    }
  }

  Future<void> makeFavourite(String deviceId, wallpaperId) async {
    try {
      if (await isInternet()) {
        DocumentSnapshot wallpaper = await _instance.collection("wallpaper").doc(wallpaperId).get();
        await _instance.collection("favourite").add({"device_id": deviceId, "wallpaper": wallpaper.reference});
      } else {
        throw Exception("No Internet Connection. Please check your internet");
      }
    } on FirebaseException catch (e) {
      throw e.message ?? 'Something went wrong';
    }
  }

  Future<void> saveFCMToken(token) async {
    try {
      if (await isInternet()) {
        var deviceInfo = DeviceInfoPlugin();
        var androidDeviceInfo = await deviceInfo.androidInfo;
        await _instance.collection("devices").doc(androidDeviceInfo.id).set({
          "device_id": androidDeviceInfo.id,
          "token": token,
          "model": androidDeviceInfo.model,
          "manufacturer": androidDeviceInfo.manufacturer,
        });
      } else {
        throw Exception("No Internet Connection. Please check your internet");
      }
    } on FirebaseException catch (e) {
      throw e.message ?? 'Something went wrong';
    }
  }

  Future<bool> isInternet() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    } else {
      return false;
    }
  }
}
