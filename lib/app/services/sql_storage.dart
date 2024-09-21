import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SQLStorageService extends GetxService {
  static SQLStorageService get to => Get.find();
  final _databaseName = "app.db";
  final _databaseVersion = 1;
  late Database _database;
  Database get database => _database;

  Future<SQLStorageService> init() async {
    try {
      var databasesPath = await getDatabasesPath();
      _database = await openDatabase(
        join(databasesPath, _databaseName),
        version: _databaseVersion,
        onOpen: (db) {},
        onCreate: _onCreate,
      );
    } catch (e) {
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
    }

    return this;
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    try {
      // ctreate stream table key autoincrement name, url, headers
      await db.execute('''
          CREATE TABLE streams (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            url TEXT NOT NULL,
            headers TEXT
          )
          ''');

      // create settings table key is th primary  key, value
      await db.execute('''
          CREATE TABLE settings (
            key TEXT PRIMARY KEY,
            value TEXT
          )
          ''');

      // create thumbnailscache table key is th primary  key, value=Uint8List
      await db.execute('''
          CREATE TABLE thumbnailscache (
            key TEXT PRIMARY KEY,
            value BLOB
          )
          ''');

      // create played list table key is primary  only
      await db.execute('''
          CREATE TABLE playedlist (
            key TEXT PRIMARY KEY
          )
          ''');
      // printAmber("[SQL] created tables!");
    } catch (e) {
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
    }
  }
}
