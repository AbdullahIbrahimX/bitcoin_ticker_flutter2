import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static final _dbName = 'BitcoinTicker.db';
  static final _dbVersion = 1;

  static final tableCrypto = 'Crypto';

  static final columnID = '_id';
  static final columnCryptoName = 'CryptoName';

  DBHelper._privateConstructor();
  static final DBHelper instance = DBHelper._privateConstructor();

  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDB();
    return _database;
  }

  _initDB() async {
    Directory docDirectory = await getApplicationDocumentsDirectory();
    String path = join(docDirectory.path, _dbName);
    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute("CREATE TABLE " +
        tableCrypto +
        " ( " +
        columnID +
        " INTEGER PRIMARY KEY," +
        columnCryptoName +
        " TEXT NOT NULL)");
    await db.insert(tableCrypto, {columnCryptoName: 'XBT'});
  }

  ///------ Helper Methods ------///
  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(tableCrypto, row);
  }

  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    return await db.query(tableCrypto);
  }

  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db
        .delete(tableCrypto, where: '$columnID = ?', whereArgs: [id]);
  }
}
