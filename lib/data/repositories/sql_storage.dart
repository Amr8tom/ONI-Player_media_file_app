import 'dart:typed_data';

import 'package:get/get.dart';
// import 'package:helpers/helpers/print.dart';
import 'package:oniplayer/app/services/sql_storage.dart';
import 'package:oniplayer/domain/models/stream.dart';
import 'package:oniplayer/domain/repositories/sql_storage_repo.dart';

class SqlStorageImpl extends SqlStorageRepository {
  static SqlStorageImpl get to => Get.find<SqlStorageImpl>();
  /* -------------------------------------------------------------------------- */
  /*                          INSERT thumbnail to cache                         */
  /* -------------------------------------------------------------------------- */
  @override
  Future<bool> setThumbnailCache(String path, Uint8List image) async {
    try {
      await SQLStorageService.to.database.insert("thumbnailscache", {
        "key": path,
        "value": image,
      });
      // printGreen("[🔗] [✅] Cached thumbnail for $path");
      return true;
    } catch (e) {
      // printRed("[🔗] [❌] setThumbnailCache $e");
      return false;
    }
  }

  /* -------------------------------------------------------------------------- */
  /*                         QUERY thumbnail from cache                         */
  /* -------------------------------------------------------------------------- */
  @override
  Future<Uint8List?> getThumbnailCache(String path) async {
    try {
      var res = await SQLStorageService.to.database.query(
        "thumbnailscache",
        where: "key = ?",
        whereArgs: [path],
      );
      if (res.isNotEmpty) {
        // printGreen("[🔗] [✅] Got thumbnail for $path");
        return res.first["value"] as Uint8List;
      } else {
        // printYellow("[🔗] [❌] No thumbnail for $path");
        return null;
      }
    } catch (e) {
      // printRed("[🔗] [❌] getThumbnailCache $e");
      return null;
    }
  }

  /* -------------------------------------------------------------------------- */
  /*                             INSERT to played list                             */
  /* -------------------------------------------------------------------------- */
  @override
  Future<bool> addToPlayedList(String path) async {
    try {
      await SQLStorageService.to.database.insert("playedlist", {
        "key": path,
      });
      // printGreen("[🔗] [✅] Added to played list $path");
      return true;
    } catch (e) {
      // printRed("[🔗] [❌] addToPlayedList $e");
      return false;
    }
  }

  /* -------------------------------------------------------------------------- */
  /*                               query played list                              */
  /* -------------------------------------------------------------------------- */
  @override
  Future<List<String>> getPlayedList() async {
    try {
      var res = await SQLStorageService.to.database.query("playedlist");
      if (res.isNotEmpty) {
        // printGreen("[🔗] [✅] Got played list");
        return res.map((e) => e["key"] as String).toList();
      } else {
        // printYellow("[🔗] [❌] No played list");
        return [];
      }
    } catch (e) {
      // printRed("[🔗] [❌] getPlayedList $e");
      return [];
    }
  }

  /* -------------------------------------------------------------------------- */
  /*                               INSERT settings                              */
  /* -------------------------------------------------------------------------- */
  @override
  Future<bool> setSetting(String key, String value) async {
    try {
      await SQLStorageService.to.database.insert("settings", {
        "key": key,
        "value": value,
      });
      // printGreen("[🔗] [✅] Set setting $key");
      return true;
    } catch (e) {
      // printRed("[🔗] [❌] setSetting $e");
      return false;
    }
  }

  /* -------------------------------------------------------------------------- */
  /*                               QUERY settings                               */
  /* -------------------------------------------------------------------------- */
  @override
  Future<String?> getSetting(String key) async {
    try {
      var res = await SQLStorageService.to.database.query(
        "settings",
        where: "key = ?",
        whereArgs: [key],
      );
      if (res.isNotEmpty) {
        // printGreen("[🔗] [✅] Got setting $key");
        return res.first["value"] as String;
      } else {
        // printYellow("[🔗] [❌] No setting $key");
        return null;
      }
    } catch (e) {
      // printRed("[🔗] [❌] getSetting $e");
      return null;
    }
  }

  /* -------------------------------------------------------------------------- */
  /*                               INSERT streams                               */
  /* -------------------------------------------------------------------------- */

  @override
  Future<bool> addStream(StreamModel stream) async {
    try {
      await SQLStorageService.to.database.insert(
        "streams",
        stream.toMap(),
      );
      // printGreen("[🔗] [✅] Added stream ${stream.name}");
      return true;
    } catch (e) {
      // printRed("[🔗] [❌] addStream $e");
      return false;
    }
  }

  /* -------------------------------------------------------------------------- */
  /*                                QUERY streams                               */
  /* -------------------------------------------------------------------------- */
  @override
  Future<List<StreamModel>> getStreams() async {
    try {
      var res = await SQLStorageService.to.database.query("streams");
      if (res.isNotEmpty) {
        // printGreen("[🔗] [✅] Got streams");
        return res.map((e) => StreamModel.fromMap(e)).toList();
      } else {
        // printYellow("[🔗] [❌] No streams");
        return [];
      }
    } catch (e) {
      // printRed("[🔗] [❌] getStreams $e");
      return [];
    }
  }

  /* -------------------------------------------------------------------------- */
  /*                                DELETE stream                               */
  /* -------------------------------------------------------------------------- */
  @override
  Future<bool> deleteStream(StreamModel stream) async {
    // where stream.url & stream.name
    try {
      await SQLStorageService.to.database.delete(
        "streams",
        where: "url = ? AND name = ?",
        whereArgs: [stream.url, stream.name],
      );
      // printGreen("[🔗] [✅] Deleted stream ${stream.name}");
      return true;
    } catch (e) {
      // printRed("[🔗] [❌] deleteStream $e");
      return false;
    }
  }

  /* -------------------------------------------------------------------------- */
  /*                                UPDATE stream                               */
  /* -------------------------------------------------------------------------- */
  @override
  Future<bool> updateStream(StreamModel oldOne, StreamModel newOne) async {
    // where stream.url & stream.namew
    try {
      SQLStorageService.to.database.update(
        "streams",
        newOne.toMap(),
        where: "url = ? AND name = ?",
        whereArgs: [oldOne.url, oldOne.name],
      );
      // printGreen("[🔗] [✅] Updated stream ${newOne.name}");
      return true;
    } catch (e) {
      // printRed("[🔗] [❌] updateStream $e");
      return false;
    }
  }
}
