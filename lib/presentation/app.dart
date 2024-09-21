import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oniplayer/app/config/app_theme.dart';
import 'package:oniplayer/presentation/controllers/home/home_controller.dart';
import 'package:oniplayer/presentation/controllers/initial.binding.dart';
import 'package:oniplayer/presentation/controllers/player/player_binding.dart';
import 'package:oniplayer/presentation/pages/folder/folders_page.dart';
import 'package:oniplayer/presentation/pages/player/player_page.dart';
import 'package:oniplayer/presentation/pages/router.dart';
import 'package:oniplayer/presentation/pages/stream/stream_page.dart';

class PlayerLauncher extends StatelessWidget {
  final dynamic args;
  const PlayerLauncher({super.key, this.args});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      darkTheme: AppTheme.darkTheme,
      initialBinding: PlayerBinding(),
      home: PlayerPage(args: args, fronIntent: true),
    );
  }
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      darkTheme: AppTheme.darkTheme,
      initialRoute: AppPages.initial,
      initialBinding: InitialBinding(),
      getPages: AppPages.routes,
    );
  }
}

class Home extends GetView<HomeController> {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        body: DoubleBackToCloseApp(
          snackBar: const SnackBar(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            content: Text('Tap back again to leave'),
          ),
          child: IndexedStack(
            index: controller.activeIndex.value,
            children: const [FoldersPage(), StreamPage()],
          ),
        ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.symmetric(vertical: 6),
          decoration: const BoxDecoration(
            color: AppTheme.backgroundColorLight,
            border: Border(
              top: BorderSide(
                color: Colors.white10,
                width: 1,
              ),
            ),
          ),
          child: BottomNavigationBar(
            onTap: controller.setActiveIndex,
            currentIndex: controller.activeIndex.value,
            selectedFontSize: 12,
            unselectedFontSize: 12,
            backgroundColor: AppTheme.backgroundColorLight,
            type: BottomNavigationBarType.fixed,
            items: [
              _bottomNavigationBarItem(
                icon: Icons.folder,
                label: 'folders',
                active: controller.activeIndex.value == 0,
              ),
              _bottomNavigationBarItem(
                icon: Icons.wifi_tethering_rounded,
                label: 'stream',
                active: controller.activeIndex.value == 1,
              ),
              // _bottomNavigationBarItem(
              //   icon: Icons.download_rounded,
              //   label: 'downloads',
              //   active: controller.activeIndex.value == 2,
              // ),
            ],
          ),
        ),
      ),
    );
  }

  _bottomNavigationBarItem(
      {required IconData icon, required String label, bool active = false}) {
    return BottomNavigationBarItem(
      icon: Padding(
          padding: const EdgeInsets.all(1.0),
          child: Icon(
            icon,
            color: active ? AppTheme.primaryColor : Colors.white,
          )),
      label: label.toLowerCase(),
    );
  }
}
