import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oniplayer/app/config/app_config.dart';
import 'package:oniplayer/app/config/app_theme.dart';
import 'package:oniplayer/app/util/util.dart';
import 'package:oniplayer/presentation/pages/router.dart';
import 'package:url_launcher/url_launcher.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppTheme.backgroundColor,
      shape: const Border(right: BorderSide(color: Colors.white10, width: 1)),
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            decoration: const BoxDecoration(
              color: AppTheme.backgroundColorLight,
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset("assets/icons/icon_TEXT.png",
                      width: MediaQuery.of(context).size.width * 0.3),
                ],
              ),
            ),
          ),
          ListTile(
            leading: const Icon(
              Icons.star,
              color: Colors.orange,
            ),
            title: const Text(
              "Rate us!",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onTap: () async {
              await launchUrl(
                Uri.parse(AppConfig.kPlayStoreURL),
                mode: LaunchMode.externalApplication,
              );
            },
          ),
          ListTile(
            //website icon
            leading: const Icon(Icons.privacy_tip, color: Colors.blueAccent),
            title: const Text(
              "Privacy policy!",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onTap: () async {
              await launchUrl(
                Uri.parse(AppConfig.privacyPolicyUrl),
                mode: LaunchMode.inAppWebView,
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.info, color: Colors.white),
            title: const Text(
              "About",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onTap: () async {
              // var verion = await Utils.getAppVersion();
              // Get.offAndToNamed(Routes.about, arguments: verion);
            },
          ),
        ],
      ),
    );
  }
}
