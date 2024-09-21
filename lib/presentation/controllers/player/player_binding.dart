import 'package:get/get.dart';
import 'package:oniplayer/presentation/controllers/player/player_controller.dart';

class PlayerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PlayerController>(() => PlayerController());
  }
}
