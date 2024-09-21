import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:oniplayer/app/config/app_config.dart';
import 'package:oniplayer/app/config/app_constants.dart';
import 'package:oniplayer/app/config/app_theme.dart';
import 'package:oniplayer/app/util/util.dart';
import 'package:oniplayer/presentation/controllers/local/folders_controller.dart';
import 'package:oniplayer/presentation/pages/router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_lifecycle_detector/flutter_lifecycle_detector.dart';

class NoPermissionPage extends StatefulWidget {
  const NoPermissionPage({super.key});

  @override
  State<NoPermissionPage> createState() => _NoPermissionPageState();
}

class _NoPermissionPageState extends State<NoPermissionPage> {
  @override
  void initState() {
    super.initState();
    FlutterLifecycleDetector().onBackgroundChange.listen((isBackground) {
      if (!isBackground) {
        Utils.getStoragePermission().then((status) {
          if (status == PermissionStatus.granted) {
            FoldersController.to.fetchVideos();
            Get.offAndToNamed(Routes.home);
          } else {
            Get.offAndToNamed(Routes.noPermission);
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Lottie.asset(
            kSad,
            height: Get.height * 0.2,
          ),
          const SizedBox(height: 5),
          Text(
            "Permission is Required!",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppTheme.textColorLight,
              fontWeight: FontWeight.w500,
              fontSize: MediaQuery.of(context).size.width * 0.05,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            "${AppConfig.kAppName} requires storage permission to play device media",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppTheme.textColor,
              fontWeight: FontWeight.w200,
              fontSize: MediaQuery.of(context).size.width * 0.04,
            ),
          ),
          const SizedBox(height: 15),
          MaterialButton(
            color: AppTheme.primaryColor,
            highlightColor: AppTheme.primaryColor.shade900,
            splashColor: Colors.transparent,
            padding: const EdgeInsets.all(15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            onPressed: () async {
              final status = await Utils.getStoragePermission();
              if (status == PermissionStatus.granted) {
                FoldersController.to.fetchVideos();
                Get.offAllNamed(Routes.home);
              } else {
                Utils.sendToAppSettings();
              }
            },
            child: const Text("Open App Settings"),
          )
        ],
      ),
    ));
  }
}
