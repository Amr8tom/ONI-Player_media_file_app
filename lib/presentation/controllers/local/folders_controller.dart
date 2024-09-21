import 'dart:math';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:get/get.dart';
import 'package:getter/getter.dart';
import 'package:oniplayer/app/services/ad_manager.dart';
import 'package:oniplayer/app/util/util.dart';
import 'package:oniplayer/data/repositories/sql_storage.dart';
import 'package:oniplayer/domain/models/folder.dart';
import 'package:oniplayer/presentation/pages/router.dart';
import 'package:in_app_review/in_app_review.dart';

class FoldersController extends GetxController {
  static FoldersController get to => Get.find<FoldersController>();
  final InAppReview inAppReview = InAppReview.instance;
  Rx<Folder> current = Folder.empty().obs;
  final byFolders = <Folder>[].obs;
  final allMedia = Folder.empty().obs;
  final played = <String>[].obs;
  RxBool done = false.obs;

  @override
  void onInit() {
    super.onInit();
    SqlStorageImpl.to.getPlayedList().then((value) {
      played.assignAll(value);
    });
  }

  Future<void> fetchVideos() async {
    Getter.get(type: GetterType.all).then((v) {
      byFolders.assignAll(Utils.mediaByFolders(v));
      done.value = true;
    }).catchError((e) {
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
    });
  }

  void addToPlayed(String path) {
    // check if already exists
    if (played.any((element) => element == path)) return;
    played.add(path);
    SqlStorageImpl.to.addToPlayedList(path);
    update(["new-tag"]);
    if (played.length > 5) {
      // random bool
      if (Random().nextBool()) {
        AdManager.to.showFacebookInterstitialAd();
      }
    }
  }

  void selectFolder(Folder folder) async {
    current.value = folder;
    Get.toNamed(Routes.videos)!.then((value) {
      // REFRESH BY FOLDERS
      byFolders.refresh();
      requestRev();
    });
  }

  // is all folder video played
  bool isAllVideoPlayed(Folder folder) {
    return folder.media
        .every((element) => played.any((e) => e == element.path.toString()));
  }

  // get number of unwatched videos
  int getUnwatchedVideos(Folder folder) {
    return folder.media
        .where((element) => !played.any((e) => e == element.path.toString()))
        .length;
  }

  bool isNew(Media media) => !played.any((e) => e == media.path.toString());

  // ask for revide
  void requestRev() async {
    if (played.length < 15) return;
    if (await inAppReview.isAvailable()) {
      inAppReview.requestReview();
    }
  }
}
