// getx route
import 'package:get/get.dart';
import 'package:oniplayer/presentation/app.dart';
import 'package:oniplayer/presentation/controllers/player/player_binding.dart';
import 'package:oniplayer/presentation/pages/about/about_page.dart';
import 'package:oniplayer/presentation/pages/noPermission/no_permission_page.dart';
import 'package:oniplayer/presentation/pages/player/player_page.dart';
import 'package:oniplayer/presentation/pages/stream/add_stream_page.dart';
import 'package:oniplayer/presentation/pages/videos/videos_page.dart';

class AppPages {
  static const initial = Routes.home;

  static final routes = [
    // GetPage(
    //   name: Routes.splash,
    //   page: () => const SplashPage(),
    // ),
    GetPage(
      name: Routes.home,
      page: () => const Home(),
    ),
    GetPage(
      name: Routes.player,
      page: () => const PlayerPage(),
      binding: PlayerBinding(),
    ),
    GetPage(
      name: Routes.videos,
      page: () => const VideosPage(),
    ),
    GetPage(
      name: Routes.noPermission,
      page: () => const NoPermissionPage(),
    ),
    GetPage(
      name: Routes.addStream,
      page: () => const AddStreamPage(),
    ),
    GetPage(
      name: Routes.about,
      page: () => const AboutPage(),
    ),
  ];
}

abstract class Routes {
  // static const splash = '/';
  static const home = '/home';
  static const player = '/player';
  static const videos = '/videos';
  static const addStream = '/addStream';
  static const about = '/about';
  static const noPermission = '/noPermission';
}
