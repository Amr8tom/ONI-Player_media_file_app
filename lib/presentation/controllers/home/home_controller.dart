import 'dart:async';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:get/get.dart';
import 'package:oniplayer/app/util/util.dart';
import 'package:oniplayer/presentation/controllers/local/folders_controller.dart';
import 'package:oniplayer/presentation/pages/router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:receive_intent/receive_intent.dart';

class HomeController extends GetxController {
  var activeIndex = 0.obs;
  var currentRoute = "/".obs;
  late StreamSubscription _sub;

  void setCurrentRoute(String route) {
    if (route == currentRoute.value) return;
    currentRoute.value = route;
  }

  void setActiveIndex(int index) {
    if (index == activeIndex.value) return;
    activeIndex.value = index;
  }

  @override
  void onInit() {
    super.onInit();
    _initReceiveIntentit();
    Utils.getStoragePermission().then((status) async {
      if (status == PermissionStatus.granted) {
        FoldersController.to.fetchVideos();
      } else {
        Get.offAndToNamed(Routes.noPermission);
      }
    }).catchError((e) {
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
    });
  }

  Future<void> _initReceiveIntentit() async {
    /* -------------------------------------------------------------------------- */
    /*                      Attach listener to receive intent                     */
    /* -------------------------------------------------------------------------- */
    _sub = ReceiveIntent.receivedIntentStream.listen((Intent? intent) async {
      var intentData = await Utils.handleIntent(inten: intent);
      if (intentData == null) return;
      Get.toNamed(Routes.player, arguments: intentData);
    }, onError: (err) {
      // Handle exception
      FirebaseCrashlytics.instance.recordError(err, StackTrace.current);
    });
  }

  @override
  void onClose() {
    _sub.cancel();
    super.onClose();
  }
}
