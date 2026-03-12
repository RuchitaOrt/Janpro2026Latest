import 'dart:convert';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  static Database? _db;

  DBHelper._internal(); // private constructor

  static DBHelper get instance => _instance;

  // Always call this to get database instance
  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  // Initialize database with versioning and upgrade logic
  static Future<Database> _initDb() async {
    final path = join(await getDatabasesPath(), 'offline_data.db');

    return await openDatabase(
      path,
      version: 2,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE offline_requests (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            url TEXT,
            payload TEXT,
            image_paths TEXT,
            supporting_image TEXT,

            is_multipart INTEGER,
            synced INTEGER
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          // Adds missing columns safely without data loss
          await db.execute(
              "ALTER TABLE offline_requests ADD COLUMN image_paths TEXT");
          await db.execute(
              "ALTER TABLE offline_requests ADD COLUMN is_multipart INTEGER DEFAULT 1");
        }
      },
    );
  }

  // Insert new offline request (works for both normal and multipart)
  // static Future<void> insertOfflineRequest(
  //   String url,
  //   Map<String, dynamic> payload, {
  //   List<String>? imagePaths,
  //   bool isMultipart = true,
  // }) async {
  //   final db = await database;
  //   await db.insert('offline_requests', {
  //     'url': url,
  //     'payload': jsonEncode(payload),
  //     'image_paths': jsonEncode(imagePaths ?? []),
  //     'is_multipart': isMultipart ? 1 : 0,
  //     'synced': 0,
  //   });
  // }

  static Future<void> insertOfflineRequest(
    String url,
    payload, {
    List<String>? imagePaths,
    List<String>? supporting_image,
    bool isMultipart = true,
  }) async {
    final db = await database;

    // Check for existing unsynced entry with the same URL and payload
    final existing = await db.query(
      'offline_requests',
      where: 'url = ? AND payload = ? AND synced = 0',
      whereArgs: [url, jsonEncode(payload)],
    );

    if (existing.isNotEmpty) {
      // Duplicate found, do not insert
      print('⚠️ Duplicate offline request skipped');
      return;
    }

    await db.insert('offline_requests', {
      'url': url,
      'payload': jsonEncode(payload),
      'image_paths': jsonEncode(imagePaths ?? []),
      'supporting_image': jsonEncode(supporting_image ?? []),
      'is_multipart': isMultipart ? 1 : 0,
      'synced': 0,
    });
  }

  // Get all unsynced requests
  static Future<List<Map<String, dynamic>>> getUnsyncedRequests() async {
    final db = await database;
    return await db.query('offline_requests', where: 'synced = 0');
  }

  // Mark request as synced (but keep record)
  static Future<void> markRequestAsSynced(int id) async {
    final db = await database;
    await db.update(
      'offline_requests',
      {'synced': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Optional: Delete request after sync
  static Future<void> deleteRequest(int id) async {
    final db = await database;
    await db.delete('offline_requests', where: 'id = ?', whereArgs: [id]);
  }

  // Optional: Clear all (for debugging)
  static Future<void> clearAll() async {
    final db = await database;
    await db.delete('offline_requests');
  }
}
