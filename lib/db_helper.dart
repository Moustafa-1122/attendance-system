import 'dart:async';

import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper {
  static Future<void> createTables(sql.Database database) async {
    await database.execute(""" CREAT TABLE data(
    id INTEGER PRIMARY KEY AUTOIINCREMENT NOT NULL,
    title TEXT,
    desc TEXT,
    creatAT TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP)""");
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase("Moustafa.db", version: 1,
        onCreate: (sql.Database database, int version) async {
          await createTables(database);
        }
    );
  }

  static Future<int> creatData(String title, String? desc, String text) async {
    final db = await SQLHelper.db();
    final data = {'title': title, 'desc': desc};
    final id = await db.insert(
        'data', data, conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  static Future<List<Map<String, dynamic>>> getData() async {
    final db = await SQLHelper.db();
    return db.query('data', orderBy: ' id');
  }

  static Future<List<Map<String, dynamic>>> getSingleData(int id) async {
    final db = await SQLHelper.db();
    return db.query('data', where: "id = ?", whereArgs: [id], limit: 1);
  }

  static Future<int> updateData(int id,String title,String? desc) async{
    final db = await SQLHelper.db();
    final data = {

      'title' :title,
      'desc' : desc,
      'createdAt' : DataTime.now().toString()
    };
    final result = await db.update('data',data,where: "id=?",whereArgs: [id]);
    return result;
  }
  static Future<void> deleteData(int id) async{
    final db = await SQLHelper.db();
    try {
      await db.delete('data', where: "id=?", whereArgs: [id]);
    }catch (e){}

  }
  }
