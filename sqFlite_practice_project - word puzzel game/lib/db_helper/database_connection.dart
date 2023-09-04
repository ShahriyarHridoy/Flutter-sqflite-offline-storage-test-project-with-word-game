import 'dart:io';

import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseConnection {
  Future<Database> setDatabase() async {
    // var directory = await getApplicationDocumentsDirectory();
    // var path = join(directory.path, 'db_crud.db');

    // final databaseExists = await databaseFactory.databaseExists(path);
    // Database database;

    // if (!databaseExists) {
    //   ByteData data = await rootBundle.load('assets/db_crud.db');
    //   List<int> bytes = data.buffer.asUint8List();
    //   await File(path).writeAsBytes(bytes);
    //   database =
    //       await openDatabase(path);
    // } else {
    //   database =
    //       await openDatabase(path, version: 1, onCreate: _createDatabase);
    // }

    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'wordGameLevel.db');
    Database database; // You can keep the database name as 'employeeInfo.db'

    final databaseExists = await databaseFactory.databaseExists(path);

    if (!databaseExists) {
      ByteData data = await rootBundle.load('assets/wordGameLevel.db');
      List<int> bytes = data.buffer.asUint8List();
      await File(path).writeAsBytes(bytes);

      database = await openDatabase(path);

      // database =
      //     await openDatabase(path, version: 1, onCreate: _createDatabase);
    } else {
      database = await openDatabase(path);
    }

    return database;
  }

  Future<void> _createDatabase(Database database, int version) async {
    String sql =
        "CREATE TABLE gameLevelData (level INTEGER PRIMARY KEY,array TEXT,country TEXT,city TEXT,letters TEXT,words Text);";
    await database.execute(sql);
  }
}
