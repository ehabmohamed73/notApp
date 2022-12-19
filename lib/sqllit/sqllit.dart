import 'dart:async';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SqlLitClass {
  static Database? db;
  Future<Database?> get() async {
    if (db == null) {
      db = await initialDb();
      return db;
    } else {
      return db;
    }
  }

  initialDb() async {
    var dbPath = await getDatabasesPath();
    String path = join(dbPath, 'notsApp.db');
    Database myDb = await openDatabase(path,
        onCreate: _dbCreate, version: 1, onUpgrade: _dbUpgrade);
    return myDb;
  }

  _dbCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE "nots" ("id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, "title" TEXT, "not" TEXT)
''');
    print("Created ==================");
  }

  readData(String sql) async {
    Database? myDb = db;
    List<Map> respons = await myDb!.rawQuery(sql);
    return respons;
  }

  insertData(String sql) async {
    Database? myDb = db;
    int respons = await myDb!.rawInsert(sql);
    return respons;
  }

  updateData(String sql) async {
    Database? myDb = db;
    int respons = await myDb!.rawUpdate(sql);
    return respons;
  }

  deleteData(String sql) async {
    Database? myDb = db;
    int respons = await myDb!.rawDelete(sql);
    return respons;
  }

  _dbUpgrade(Database db, int oldVersion, int newVersion) {}
}
