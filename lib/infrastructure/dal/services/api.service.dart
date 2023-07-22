import 'package:anime_wallpapers/infrastructure/dal/services/dto/categories.response.dart';

import '../../../domain/core/abstractions/http_connect.interface.dart';
import '../../../domain/core/exceptions/default.exception.dart';
import 'dto/add.token.response.dart';
import 'dto/wallpaper.response.dart';
import 'package:device_info_plus/device_info_plus.dart';

class ApiService {
  final IHttpConnect _connect;

  const ApiService(IHttpConnect connect) : _connect = connect;

  Future<CategoriesResponse> getCategories() async {
    final response = await _connect.get(
      'get-categories?app_id=1',
      decoder: (value) => CategoriesResponse.fromJson(
        value as Map<String, dynamic>,
      ),
    );

    if (response.success) {
      return response.payload!;
    } else {
      switch (response.statusCode) {
        default:
          throw DefaultException(message: response.payload!.message!);
      }
    }
  }

  Future<WallpaperResponse> getWallpapers(id) async {
    final response = await _connect.get(
      'get-wallpapers${id != null ? '?category_id=$id&app_id=1' : '?app_id=1'}',
      decoder: (value) => WallpaperResponse.fromJson(
        value as Map<String, dynamic>,
      ),
    );

    if (response.success) {
      return response.payload!;
    } else {
      switch (response.statusCode) {
        default:
          throw DefaultException(message: response.payload!.message!);
      }
    }
  }

  Future<AddTokenResponse> addToken(token) async {
    var deviceInfo = DeviceInfoPlugin();
    var androidDeviceInfo = await deviceInfo.androidInfo;
    final response = await _connect.get(
      'add-token?device_id=${androidDeviceInfo.id}&token=$token&app_id=1',
      decoder: (value) => AddTokenResponse.fromJson(
        value as Map<String, dynamic>,
      ),
    );

    if (response.success) {
      return response.payload!;
    } else {
      switch (response.statusCode) {
        default:
          throw DefaultException(message: response.payload!.message!);
      }
    }
  }
}
