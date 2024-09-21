import 'package:flutter/material.dart';
import 'package:oniplayer/app/util/dependency.dart';
import 'package:oniplayer/app/util/util.dart';
import 'package:oniplayer/domain/models/local_source.dart';
import 'package:oniplayer/domain/models/stream_source.dart';
import 'package:oniplayer/presentation/app.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  final intentData = await Utils.handleIntent();
  // FlutterNativeSplash.remove();

  // runApp(GetMaterialApp(
  //   debugShowCheckedModeBanner: false,
  //   theme: AppTheme.darkTheme,
  //   darkTheme: AppTheme.darkTheme,
  //   home: TestPage(arg: intentData),
  // ));
  // return;
  // final intentData = LocalSource(
  //     path:
  //         "/data/data/com.oniplayer.app.oniplayer/files/uri_to_file/rio_from_above_compressed.mp4");

  if (intentData is StreamSource || intentData is LocalSource) {
    /* -------------------------------------------------------------------------- */
    /*                           launch player only                           */
    /* -------------------------------------------------------------------------- */
    FlutterNativeSplash.remove();
    if (intentData is StreamSource) Utils.enableLandscapMode(true);
    await DependencyCreator.initPlayerSerices();
    // await Utils.getStoragePermission();
    // runApp(GetMaterialApp(
    //   debugShowCheckedModeBanner: false,
    //   theme: AppTheme.darkTheme,
    //   darkTheme: AppTheme.darkTheme,
    //   home: TestPage(arg: intentData),
    // ));
    // printRed("intentData: $intentData");
    runApp(PlayerLauncher(args: intentData));
  } else {
    /* -------------------------------------------------------------------------- */
    /*                            launch the whole app                            */
    /* -------------------------------------------------------------------------- */
    await DependencyCreator.initAllServices();
    FlutterNativeSplash.remove();
    runApp(const App());
  }
}
