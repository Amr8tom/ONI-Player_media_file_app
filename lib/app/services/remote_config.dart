import 'dart:convert';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:get/get.dart';
// import 'package:helpers/helpers/print.dart';
import 'package:oniplayer/app/services/ad_manager.dart';
import 'package:oniplayer/domain/models/config_model.dart';

class ConfigService extends GetxService {
  static ConfigService get to => Get.find();
  RConfigModel remoteConfig = RConfigModel.empty();
  final FirebaseRemoteConfig firebaseRemoteConfig =
      FirebaseRemoteConfig.instance;

  Future<void> init() async {
    try {
      firebaseRemoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 10),
          minimumFetchInterval: const Duration(minutes: 4),
        ),
      );
      firebaseRemoteConfig.fetchAndActivate().then((value) {
        remoteConfig = RConfigModel.fromJson(
          jsonDecode(firebaseRemoteConfig.getString('config')),
        );
        initAds();
      });
    } catch (e) {
      // printRed(e);
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
    }
  }

  Future<void> initAds() async {
    if (!remoteConfig.adsEnabled) return;
    try {
      AdManager.to.init(
        remoteConfig.fInterstitialAdId,
        remoteConfig.fNativeBannerAdId,
      );
    } catch (e) {
      // printRed("initas: $e");
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
    }
  }
}
