import 'package:flutter/cupertino.dart';
import 'package:getter/getter.dart';

class LocalSource {
  final String path;
  Orientation orientation;
  LocalSource({required this.path, required this.orientation});

  // decode name
  String get name {
    try {
      return Uri.decodeFull(path.split('/').last);
    } catch (e) {
      return path.split('/').last;
    }
  }

  @override
  String toString() => 'LocalSource(file: $path)';
}
