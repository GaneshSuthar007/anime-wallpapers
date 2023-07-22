import 'package:get/get_connect/connect.dart';
import 'package:get/get.dart';
import 'package:anime_wallpapers/domain/api/api.repository.dart';
import 'package:anime_wallpapers/infrastructure/dal/services/api.service.dart';

import '../../../dal/connect.dart';

class ApiRepositoryBinding {
  late APiRepository _apiRepository;

  APiRepository get repository => _apiRepository;

  ApiRepositoryBinding() {
    final getConnect = Get.find<GetConnect>();
    final connect = Connect(connect: getConnect);
    final apiService = ApiService(connect);
    _apiRepository = APiRepository(apiService: apiService);
  }
}
