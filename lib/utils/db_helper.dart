
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sample_todo_app/model/db/definition.dart';
import 'package:sample_todo_app/model/db/queries.dart';
import 'package:sample_todo_app/model/task_model.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static final DBHelper _dbHelper = DBHelper._internal();
  
  DBHelper._internal();

  factory DBHelper() {
    return _dbHelper;
  }

  static Database? _database; // DBの実態

  Map<int, List<String>> migrations = {
    2 : migration1To2
  };

  // DB取得、DBが存在しない場合は初期化
  Future<Database> get database async {
    print('get database start');

    if(_database != null) {
      // 「!」必要？
      return _database!;
    }
    
    await init();

    return _database!;
  }

  // DBの初期化処理
  Future<void> init() async {
    // path_provider
    final directory = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationSupportDirectory();

    // path
    String path= join(directory!.path,databaseName);
    _database =  await openDatabase(
      path,
      version: databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
    print('database initialized');
  }

  Future<bool> insert(TaskModel model) async {
    final dbClient = await _dbHelper.database;

    Map<String, dynamic> row = {
        "title" : model.title,
        "description": model.description,
        "priority": "High"
    };

    try {
      await dbClient.insert(table, row);
      print('success to insert data');
      return true;     
    } catch (e) {
      print('failed to insert data');
      return false;
    }
  }

    Future<void> deleteTodo(int key) async {
    final dbClient = await _dbHelper.database;
    await dbClient.delete(table, where: 'key = ?', whereArgs: [key]);
  }
  

  Future<List<TaskModel>> getTasks() async {
    final dbClient = await _dbHelper.database;

    List<Map<String, dynamic>> result = await dbClient.query(table);

    return List.generate(result.length, (index) => TaskModel.fromMap(result[index]));
  }
  

  Future _onCreate(Database database, int version) async {
    await database.execute(createTasksTable);
  }

  Future _onUpgrade(Database database, int oldVersion, int newVersion) async {
    for (var i = oldVersion + 1; i <= newVersion; i++) {
      var queries = migrations[i];
      if (queries != null) {
        for (String query in queries) {
          await database.execute(query);
        }
      }
    }
  }
}