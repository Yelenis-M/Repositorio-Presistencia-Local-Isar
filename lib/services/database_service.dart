import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._init();
  static Database? _database;

  DatabaseService._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('app.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE favorites(id INTEGER PRIMARY KEY, movie_id INTEGER UNIQUE, title TEXT)',
        );
      },
    );
  }

  Future<int> insertFavorite(int movieId, String title) async {
    final db = await database;
    return await db.insert(
      'favorites',
      {'movie_id': movieId, 'title': title},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getFavorites({int limit = 10, int offset = 0}) async {
    final db = await database;
    return await db.query(
      'favorites',
      limit: limit,
      offset: offset,
    );
  }
}