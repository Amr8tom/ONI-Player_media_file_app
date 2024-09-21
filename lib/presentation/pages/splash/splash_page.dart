import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oniplayer/app/util/util.dart';
import 'package:oniplayer/presentation/controllers/local/folders_controller.dart';
import 'package:oniplayer/presentation/pages/router.dart';
import 'package:permission_handler/permission_handler.dart';
// import 'package:oni_playe/controllers/local.controller.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          "assets/icons/logo.png",
          width: 120,
        ),
      ),
    );
  }
}
