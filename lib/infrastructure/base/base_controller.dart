import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import '../../infrastructure/base/page_state.dart';
import 'app_lifecycle_reactor.dart';
import 'app_open_manager.dart';

abstract class BaseController extends GetxController {
  final _pageSateController = PageState.DEFAULT.obs;
  late AppLifecycleReactor _appLifecycleReactor;
  late StreamSubscription<ConnectivityResult> subscription;

  PageState get pageState => _pageSateController.value;
  updatePageState(PageState state) => _pageSateController(state);

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  static const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'Anime Wallpapers', // title
    description: "Checkout our new Anime added.", // description
    importance: Importance.max,
  );

  showLoading() {
    updatePageState(PageState.LOADING);
  }

  resetPageState() => _pageSateController(PageState.DEFAULT);

  hideLoading() => resetPageState();

  @override
  void onInit() {
    super.onInit();
    AppOpenAdManager appOpenAdManager = AppOpenAdManager()..loadAd();
    _appLifecycleReactor = AppLifecycleReactor(appOpenAdManager: appOpenAdManager);
    _appLifecycleReactor.listenToAppStateChanges();
    subscription =  Connectivity().onConnectivityChanged.listen((event) {
      onConnectionChange(event);
    });
    _initNotification();
  }


  void onConnectionChange(ConnectivityResult result);

  void onTokenChange(String? result);

  @override
  void onClose() {
    super.onClose();
    _pageSateController.close();
    subscription.cancel();
  }

  _initNotification() async {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
    FirebaseMessaging.instance.getToken().then((value) {
      String? token = value;
      onTokenChange(token);
    });

    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      String? token = newToken;
      onTokenChange(token);
    });


    FirebaseMessaging.onMessage.listen((RemoteMessage message)
    {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if(notification!= null && android != null){
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channelDescription: channel.description,
                icon: "@drawable/ic_notification_icon",
              ),
            ));
      }
    });

    //FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  }

  Future _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    if(notification!= null && android != null){
      flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelDescription: channel.description,
              icon: "@drawable/ic_notification_icon",
            ),
          ));
    }
  }
}
