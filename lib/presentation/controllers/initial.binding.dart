import 'package:get/get.dart';
import 'package:oniplayer/presentation/controllers/home/home_controller.dart';
import 'package:oniplayer/presentation/controllers/local/folders_controller.dart';
import 'package:oniplayer/presentation/controllers/stream/stream.controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<HomeController>(HomeController(), permanent: true);
    Get.put<FoldersController>(FoldersController(), permanent: true);
    Get.put<StreamController>(StreamController(), permanent: true);
  }
}
