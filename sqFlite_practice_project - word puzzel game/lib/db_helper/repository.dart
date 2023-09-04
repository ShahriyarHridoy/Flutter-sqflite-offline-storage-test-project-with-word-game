
import 'package:sqflite/sqflite.dart';

import 'database_connection.dart';

class Repository
{
  late DatabaseConnection _databaseConnection;
  Repository(){
    _databaseConnection = DatabaseConnection();
  }
  static Database? _database;
  Future<Database?> get database async {
    if (_database != null) {
      return _database;
    } else {
      _database = await _databaseConnection.setDatabase();
      return _database;
    }
  }

  //Insert GameLevel
  insertData(table, data) async {
    var connection = await database;
    return await connection?.insert(table, data);
  }
  //Read All Record
  readData(table) async {
    var connection = await database;
    return await connection?.query(table);
  }

  //Read a Single Record By ID
  readDataById(table, itemId) async {
    var connection = await database;
    return await connection?.query(table, where: 'level=?', whereArgs: [itemId]);
  }
  //Update GameLevel
  updateData(table, data) async {
    var connection = await database;
    return await connection
        ?.update(table, data, where: 'level=?', whereArgs: [data['level']]);
  }

  //Delete GameLevel
  deleteDataById(table, itemId) async {
    var connection = await database;
    return await connection?.rawDelete("delete from $table where level=$itemId");
  }

}