import 'package:anime_wallpapers/infrastructure/dal/services/api.service.dart';
import 'package:anime_wallpapers/infrastructure/dal/services/dto/add.token.response.dart';

import '../../infrastructure/dal/services/dto/categories.response.dart';
import '../../infrastructure/dal/services/dto/wallpaper.response.dart';

class APiRepository {
  final ApiService _apiService;

  APiRepository({
    required ApiService apiService,
  }) : _apiService = apiService;

  Future<List<CategoriesResponseData>?> getCategories() async {
    try {
      final response = await _apiService.getCategories();
      return response.data;
    } catch (err) {
      rethrow;
    }
  }

  Future<List<WallpaperResponseData>?> getWallpapers([id]) async {
    try {
      final response = await _apiService.getWallpapers(id);
      return response.data;
    } catch (err) {
      rethrow;
    }
  }

  Future<AddTokenResponse?> addToken(token) async {
    try {
      final response = await _apiService.addToken(token);
      return response;
    } catch (err) {
      rethrow;
    }
  }
}
