import 'bindings/domains/firebase.repository.binding.dart';

class Routes {
  static Future<String> get initialRoute async {
    return SPLASH;
    // try {
    //   final authDomainService = AuthRepositoryBinding().repository;
    //   final authenticated = await authDomainService.isAuthenticated();
    //   return !authenticated ? login : home;
    // } catch (err) {
    //   return login;
    // }
  }

  static const CONTENT = '/content';
  static const SPLASH = '/splash';
  static const WALLPAPERS = '/wallpapers';
  static const home = '/home';
  static const login = '/login';
  static const PREVIEW = '/preview';
}
