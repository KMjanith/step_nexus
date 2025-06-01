import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'app_database.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE walking_sessions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        time_based INTEGER NOT NULL,
        distance_based INTEGER NOT NULL,
        step_based INTEGER NOT NULL,
        target_steps INTEGER,
        target_distance REAL,
        target_time INTEGER,
        result_steps INTEGER,
        result_distance REAL,
        result_avg_speed REAL,
        burned_calories REAL,
        time_spend TEXT,
        date TEXT NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE cycling_sessions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        time_based INTEGER NOT NULL,
        distance_based INTEGER NOT NULL,
        target_distance REAL,
        target_time INTEGER,
        result_distance REAL,
        result_avg_speed REAL,
        time_spend TEXT,
        burned_calories REAL,
        date TEXT NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE travelling_sessions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        time_based INTEGER NOT NULL,
        distance_based INTEGER NOT NULL,
        target_distance REAL,
        target_time INTEGER,
        result_distance REAL,
        result_avg_speed REAL,
        time_spend TEXT,
        date TEXT NOT NULL
      )
    ''');

    await db.execute('''
  CREATE TABLE scheduled_walks (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    date TEXT NOT NULL,
    goal_type TEXT NOT NULL,        -- 'time', 'distance', 'steps'
    goal_value REAL NOT NULL,       -- e.g., 30 mins or 2.5 km or 4000 steps
    start_time TEXT NOT NULL        -- e.g., "07:30"
  )
''');
  }

  Future<void> deleteDatabaseFile() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'app_database.db');
    final file = File(path);
    if (await file.exists()) {
      await file.delete();
      print('Database deleted');
    }
  }

  //-------------------------------------------------WALKING---------------------------------------------------------

  // Insert a walking session
  Future<int> insertWalkingSession(Map<String, dynamic> session) async {
    final db = await instance.database;
    return await db.insert('walking_sessions', session);
  }

  // Get all walking sessions
  Future<List<Map<String, dynamic>>> getAllWalkingSessions() async {
    final db = await instance.database;
    return await db.query('walking_sessions');
  }

  // Get walking sessions where step_based = 1
  Future<List<Map<String, dynamic>>> getStepBasedWalkingSessions() async {
    final db = await instance.database;
    return await db.query(
      'walking_sessions',
      where: 'step_based = ?',
      whereArgs: [1],
    );
  }

  // Get walking sessions where step_based = 1
  Future<List<Map<String, dynamic>>> getDistanceBasedWalkingSessions() async {
    final db = await instance.database;
    return await db.query(
      'walking_sessions',
      where: 'distance_based = ?',
      whereArgs: [1],
    );
  }

// Get walking sessions where step_based = 1
  Future<List<Map<String, dynamic>>> getTimeBsedWalkingSessions() async {
    final db = await instance.database;
    return await db.query(
      'walking_sessions',
      where: 'time_based = ?',
      whereArgs: [1],
    );
  }

  // Update a walking session
  Future<int> updateWalkingSession(int id, Map<String, dynamic> session) async {
    final db = await instance.database;
    return await db.update(
      'walking_sessions',
      session,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Delete a walking session
  Future<int> deleteWalkingSession(int id) async {
    final db = await instance.database;
    return await db.delete(
      'walking_sessions',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  //--------------------------------------------------------cycling and travelling-----------------------------------------------------------
  // Insert a cycling or travelling session
  Future<int> insertCyclingOrTravellingSession(
      Map<String, dynamic> session, String tableName) async {
    final db = await instance.database;
    return await db.insert(
        tableName == 'cycling' ? 'cycling_sessions' : 'travelling_sessions',
        session);
  }

  // Get all cycling or travelling sessions
  Future<List<Map<String, dynamic>>> getAllCyclingOrTravellingSessions(
      String tableName) async {
    final db = await instance.database;
    return await db.query(
        tableName == 'cycling' ? 'cycling_sessions' : 'travelling_sessions');
  }

  // Get cycling or travelling sessions where step_based = 1
  Future<List<Map<String, dynamic>>>
      getDistanceBasedCyclingOrTravellingSessions(String tableName) async {
    final db = await instance.database;
    return await db.query(
      tableName == 'cycling' ? 'cycling_sessions' : 'travelling_sessions',
      where: 'distance_based = ?',
      whereArgs: [1],
    );
  }

// Get cycling or travelling sessions where step_based = 1
  Future<List<Map<String, dynamic>>> getTimeBsedCyclingOrTravellingSessions(
      String tableName) async {
    final db = await instance.database;
    return await db.query(
      tableName == 'cycling' ? 'cycling_sessions' : 'travelling_sessions',
      where: 'time_based = ?',
      whereArgs: [1],
    );
  }

  // Update a cycling or travelling session
  Future<int> updateCyclingOrTravellingSession(
      int id, Map<String, dynamic> session, String tableName) async {
    final db = await instance.database;
    return await db.update(
      tableName == 'cycling' ? 'cycling_sessions' : 'travelling_sessions',
      session,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Delete a cycling or travelling session
  Future<int> deleteCyclingOrTravellingSession(int id, String tableName) async {
    final db = await instance.database;
    return await db.delete(
      tableName == 'cycling' ? 'cycling_sessions' : 'travelling_sessions',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  //--------------------------------------------------------SCHEDULED WALKS-----------------------------------------------------------
// Insert a new schedule
  Future<int> insertScheduledWalk(Map<String, dynamic> data) async {
    final db = await instance.database;
    return await db.insert('scheduled_walks', data);
  }

// Get all schedules
  Future<List<Map<String, dynamic>>> getAllScheduledWalks() async {
    final db = await instance.database;
    return await db.query('scheduled_walks');
  }

// Get schedules for a specific date
  Future<List<Map<String, dynamic>>> getSchedulesByDate(String date) async {
    final db = await instance.database;
    return await db.query(
      'scheduled_walks',
      where: 'date = ?',
      whereArgs: [date],
    );
  }

// Optional: Delete a schedule
  Future<int> deleteScheduledWalk(int id) async {
    final db = await instance.database;
    return await db.delete(
      'scheduled_walks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Map<String, dynamic>>> getRemindersByDate(String date) async {
    final db = await database;
    return await db.query(
      'scheduled_walks',
      where: 'date = ?',
      whereArgs: [date],
    );
  }
}
