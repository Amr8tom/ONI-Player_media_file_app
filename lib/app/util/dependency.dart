import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:get/get.dart';
import 'package:oniplayer/app/services/ad_manager.dart';
import 'package:oniplayer/app/services/remote_config.dart';
import 'package:oniplayer/app/services/sql_storage.dart';
import 'package:oniplayer/data/repositories/sql_storage.dart';
import 'package:oniplayer/firebase_options.dart';

abstract class DependencyCreator {
  static initPlayerSerices() async {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    Get.put(AdManager(), permanent: true);
    Get.put(ConfigService(), permanent: true);
    ConfigService.to.init().catchError((e) {
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
    });
  }

  static initAllServices() async {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    Get.put(AdManager(), permanent: true);
    Get.put(SqlStorageImpl(), permanent: true);
    await Get.putAsync(() => SQLStorageService().init(), permanent: true);
    Get.put(ConfigService(), permanent: true);
    ConfigService.to.init();
  }
}
