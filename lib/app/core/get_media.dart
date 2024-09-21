import 'package:flutter/services.dart';

class GetMedia {
  static const methodChannel = MethodChannel("com.oniplayer.app/get_media");
  static Future<String> getMedia() async {
    final String media = await methodChannel.invokeMethod("getMedia");
    return media;
  }
}
