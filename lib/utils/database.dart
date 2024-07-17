import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path_provider/path_provider.dart';

import 'package:batt247/models/machines.dart';
import 'package:batt247/models/records.dart';
import 'package:batt247/models/sources.dart';

class AppDB {
  static final AppDB instance = AppDB._();
  AppDB._();

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
    String path = join(appDocumentsDir.path, ".dbs", 'bam247.db');
    print(path);
    return await databaseFactory.openDatabase(path, options: OpenDatabaseOptions(version: 1, onCreate: _createDatabase,));
  }

  Future<void> _createDatabase(Database db, _) async {
    return await db.execute('''
      CREATE TABLE ${SourceModel.tableName}(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        source_id CHARACTER(36),
        type_code VARCHAR(32),
        name VARCHAR(256),
        description TEXT,
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
        employee_code VARCHAR(64),
        employee_name TEXT,
        attendance_time INT,
        created_time INT,
        synced_time INT
      );
    ''');
  }

  Future<int> createSource(Map<String, dynamic> object) async {
    final db = await instance.database;
    object['created_time'] = DateTime.now().toUtc().millisecondsSinceEpoch;
    return await db.insert(SourceModel.tableName, object, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<SourceModel>> readAllSource() async {
    final db = await instance.database;
    var res = await db.query(SourceModel.tableName);
    List<SourceModel> list = res.isNotEmpty ? res.map((s) => SourceModel.fromMap(s)).toList(): [];
    return list;
  }

  Future<SourceModel> readSource(String id) async {
    final db = await instance.database;
    final results = await db.query(SourceModel.tableName, where: 'source_id = ?', whereArgs: [id]);
    if (results.isNotEmpty) {
      return SourceModel.fromMap(results.first);
    }
    throw Exception('ID $id not found.');
  }

  Future<int> updateSource(SourceModel source) async {
    final db = await instance.database;
    return await db.update(SourceModel.tableName, source.toMap(), where: 'source_id = ?', whereArgs: [source.sourceId]);
  }

  Future<int> deleteSource(String id) async {
    final db = await instance.database;
    return await db.delete(SourceModel.tableName, where: 'source_id = ?', whereArgs: [id]);
  }

  Future<int> createMachine( Map<String, dynamic> object) async {
    final db = await instance.database;
    return await db.insert(MachineModel.tableName, object, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> deleteMachine(String sourceId) async {
    final db = await instance.database;
    return await db.delete(MachineModel.tableName, where: 'source_id = ?', whereArgs: [sourceId]);
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}