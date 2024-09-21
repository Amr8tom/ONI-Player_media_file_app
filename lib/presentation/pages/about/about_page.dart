import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oniplayer/app/config/app_config.dart';
import 'package:oniplayer/app/config/app_theme.dart';

import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatelessWidget {
  static const String routeName = "/about";
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawerEnableOpenDragGesture: false,
        appBar: AppBar(
          backgroundColor: AppTheme.backgroundColorLight,
          titleSpacing: 0,
          shape:
              const Border(bottom: BorderSide(color: Colors.white10, width: 1)),
          elevation: 4,
          title: const Text(
            "About",
            style: TextStyle(
              color: AppTheme.textColorLight,
              fontWeight: FontWeight.w300,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded,
                color: AppTheme.textColorLight),
            onPressed: () {
              Get.back();
            },
          ),
          actions: [
            PopupMenuButton(
                icon: const Icon(Icons.more_vert_rounded,
                    color: AppTheme.textColorLight),
                itemBuilder: (context) {
                  return const [
                    PopupMenuItem<int>(
                      value: 0,
                      child: Text("Privacy Policy"),
                    ),
                    // PopupMenuItem<int>(
                    //   value: 1,
                    //   child: Text("TOS"),
                    // ),
                  ];
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                  side: const BorderSide(color: Colors.white10, width: 1),
                ),
                position: PopupMenuPosition.under,
                tooltip: "more",
                color: AppTheme.backgroundColorLight,
                onSelected: (value) async {
                  if (value == 0) {
                    await launchUrl(
                      Uri.parse(AppConfig.privacyPolicyUrl),
                      mode: LaunchMode.inAppWebView,
                    );
                  }
                }),
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),
              Image.asset("assets/icons/icon_TEXT.png",
                  width: MediaQuery.of(context).size.width * 0.3),
              const SizedBox(height: 10),
              Text(
                "Version ${Get.arguments ?? AppConfig.kAppVersion}",
                style: const TextStyle(color: AppTheme.textColor, fontSize: 15),
              ),
              const Text(
                "Developed by: ${AppConfig.kDevelopedBy}",
                style: TextStyle(color: AppTheme.textColor, fontSize: 15),
              ),
              const Spacer(),
              Text(
                " © ${DateTime.now().year} ${AppConfig.kDevelopedBy}",
                style: const TextStyle(color: AppTheme.textColor, fontSize: 15),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ));
  }
}
