import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path_provider/path_provider.dart';

import 'package:batt247/models/machines.dart';
import 'package:batt247/models/records.dart';
import 'package:batt247/models/source_types.dart';
import 'package:batt247/models/sources.dart';

class Batt247Database {
  static final Batt247Database instance = Batt247Database._();
  Batt247Database._();

  static Database? _database;

  // Singleton
  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    sqfliteFfiInit();
    final databaseFactory = databaseFactoryFfi;
    final Directory appDocumentsDir = await getApplicationDocumentsDirectory();
    String path = join(appDocumentsDir.path, "dbs", 'batt247.db');
    print(path);
    return await databaseFactory.openDatabase(path, options: OpenDatabaseOptions(version: 1, onCreate: _createDatabase,));
  }

  Future<void> _createDatabase(Database db, _) async {
    return await db.execute('''
      CREATE TABLE ${SourceTypeModel.tableName}(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        code VARCHAR(16), 
        name VARCHAR(256)
      );
      CREATE TABLE ${SourceModel.tableName}(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        source_id CHARACTER(36),
        name VARCHAR(256),
        description TEXT,
        type VARCHAR(256),
        interval_in_seconds INT,
        realtime_enabled INT, 
        client_endpoint TEXT,
        client_id TEXT,
        client_secret TEXT,
        created_time INT
      );
      CREATE TABLE ${MachineModel.tableName}(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        source_id CHARACTER(36),
        brandname VARCHAR(64),
        ip_address VARCHAR(64),
        tcp_port INT,
        realtime_capturable INT,
        metadata TEXT
      );
      CREATE TABLE ${RecordModel.tableName}(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        record_id CHARACTER(36),
        source_id CHARACTER(36),
        employee_code VARCHAR(256),
        employee_name TEXT,
        attendance_time INT,
        created_time INT,
        synced_time INT
      );
      INSERT INTO ${SourceTypeModel.tableName}(code, name) VALUES ('machine', 'Attendance machines');
    ''');
  }

  Future<SourceModel> create(SourceModel source) async {
    final db = await instance.database;
    final id = await db.insert(SourceModel.tableName, source.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    return source.copy(id: id);
  }

  Future<List<SourceModel>> getAllSource() async {
    final db = await instance.database;
    var res = await db.query(SourceModel.tableName);
    List<SourceModel> list = res.isNotEmpty ? res.map((s) => SourceModel.fromMap(s)).toList(): [];
    return list;
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}