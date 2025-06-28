import 'dart:async';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  AppDatabase._internal();
  static final AppDatabase instance = AppDatabase._internal();

  static Database? _database;

  Future<Database> get db async {
    return _database ??= await _openConnection();
  }

  Future<Database> _openConnection() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    return openDatabase(
      join(dbFolder.path, 'todo.db'),
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE todo (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL
          )
          ''');
  }
}
