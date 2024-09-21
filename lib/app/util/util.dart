// import 'package:appcheck/appcheck.dart';

// ignore_for_file: constant_identifier_names

import 'dart:convert';
import 'dart:io';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:getter/getter.dart';
import 'package:oniplayer/app/config/app_constants.dart';
import 'package:oniplayer/domain/models/folder.dart';
import 'package:oniplayer/domain/models/local_source.dart';
import 'package:oniplayer/domain/models/stream_source.dart';
// import 'package:package_info_plus/package_info_plus.dart';
// import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:receive_intent/receive_intent.dart';
import 'package:uri_to_file/uri_to_file.dart';

abstract class Utils {
  static const String STREAM_INTENT_TAG = "ONIPLAYER_PLAY_STREAM_ACTION";
  static const String VIEW_INTENT_TAG = "android.intent.action.VIEW";
  static String getImagePath(String name, {String format = 'png'}) {
    return 'assets/images/$name.$format';
  }

  static String getIconPath(String name, {String format = 'png'}) {
    return 'assets/icons/$name.$format';
  }

  static Widget getIcon(String name,
      {String format = 'png', double width = 33, Color? color}) {
    return Image.asset(
      getIconPath(name, format: format),
      width: width,
      color: color,
    );
  }

  static Future<dynamic> handleIntent({dynamic inten}) async {
    try {
      final intent = inten ?? await ReceiveIntent.getInitialIntent();
      if (intent != null) {
        if (intent.action == STREAM_INTENT_TAG && intent.extra != null) {
          var jsonStr = intent.extra!["stream"];
          return StreamSource.fromJsonString(MiniEnc.dec(jsonStr, kID));
        } else {
          if (VIEW_INTENT_TAG == intent.action && intent.data != null) {
            var uriString = intent.data as String;
            File file = await toFile(uriString);
            return LocalSource(
                path: file.path, orientation: Orientation.landscape);
          }
        }
      }
      return null;
    } catch (e) {
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      return null;
    }
  }

  static String getNameFromPath(String path) {
    try {
      return Uri.decodeFull(path.split('/').last);
    } catch (e) {
      return path.split('/').last;
    }
  }

  // static Future<String> getAppVersion() async {
  // PackageInfo packageInfo = await PackageInfo.fromPlatform();
  // return packageInfo.version;
  // }

  static List<Folder> mediaByFolders(List<dynamic> m) {
    List<Folder> folders = [];
    Map<String, Folder> folderMap = {};

    for (var media in m) {
      List<String> pathParts = media.path.split('/');
      String folderName = pathParts[pathParts.length - 2];

      if (folderMap.containsKey(folderName)) {
        folderMap[folderName]?.media.add(media);
      } else {
        folderMap[folderName] = Folder(name: folderName, media: [media]);
        folders.add(folderMap[folderName]!);
      }
    }

    return folders;
  }

  // get storage permission
  static Future<PermissionStatus> getStoragePermission() async {
    PermissionStatus permission = await Permission.storage.request();
    return permission;
  }

  static sendToAppSettings() {
    openAppSettings();
  }

  static String formatFileSize(int size) {
    if (size < 1024) {
      return '$size B';
    } else if (size < 1024 * 1024) {
      return '${(size / 1024).toStringAsFixed(2)} KB';
    } else if (size < 1024 * 1024 * 1024) {
      return '${(size / 1024 / 1024).toStringAsFixed(2)} MB';
    } else {
      return '${(size / 1024 / 1024 / 1024).toStringAsFixed(2)} GB';
    }
  }

  // format duration
  static String formatDuration(int miliseconds) {
    // return hh:mm:ss remove hh if 0
    Duration duration = Duration(milliseconds: miliseconds.toInt());
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    if (duration.inHours == 0) {
      return "$twoDigitMinutes:$twoDigitSeconds";
    }
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  // static Future<bool> isAppInstalled(String packageName) async {
  //   try {
  //     return await AppCheck.checkAvailability(packageName) != null;
  //   } catch (e) {
  //     return false;
  //   }
  // }

  // imursive fullscreen
  static Future<void> enableLandscapMode(bool landscap) async {
    if (landscap) {
      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    } else {
      await SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.manual,
        overlays: SystemUiOverlay.values,
      );
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
    }
  }
}

// chekk url if it is a video by checking
abstract class VideoLinkChecker {
  // regex of all video extensions
  static RegExp videoExtensions = RegExp(r'\.(mp4|ts)$');
  // check if mp4 or m3u8 or ts= or video/mp4
  static RegExp videoTypes = RegExp(r'ts=');

  static bool isVideo(String url) {
    return videoExtensions.hasMatch(url) || videoTypes.hasMatch(url);
  }
}

abstract class MiniEnc {
  static String enc(String text, String length32Key) {
    final key = encrypt.Key.fromUtf8(length32Key);
    final b64key = encrypt.Key.fromBase64(base64Url.encode(key.bytes));
    final fernet = encrypt.Fernet(b64key);
    final encrypter = encrypt.Encrypter(fernet);
    return encrypter.encrypt(text).base64;
  }

  static String dec(String encrypted, String length32Key) {
    final key = encrypt.Key.fromUtf8(length32Key);
    final b64key = encrypt.Key.fromBase64(base64Url.encode(key.bytes));
    final fernet = encrypt.Fernet(b64key);
    final encrypter = encrypt.Encrypter(fernet);
    return encrypter.decrypt(encrypt.Encrypted.fromBase64(encrypted));
  }
}
