
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sample_todo_app/model/task_model.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static final DBHelper _dbHelper = DBHelper._internal();
  
  DBHelper._internal();

  factory DBHelper() {
    return _dbHelper;
  }

  static Database? _database; // DBの実態

  final _databaseName = "MyDatabase.database"; // DB名
  final _databaseVersion = 1; // スキーマのバージョン指定
  final _table = "Tasks";
  

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
    String path= join(directory!.path,_databaseName);
    _database =  await openDatabase(path, version: _databaseVersion ,onCreate: _onCreate);
    print('database initialized');
  }

  Future<TaskModel> insert(TaskModel model) async {
    final dbClient = await _dbHelper.database;

    Map<String, dynamic> row = {
        "title" : model.title,
        "description": model.description,
        "priority": "High"
      };
    int id = await dbClient.insert(_table, row);      
    print('succedd to insert data. $id');
    
    return model;
  }

  Future<List<TaskModel>> getTasks() async {
    final dbClient = await _dbHelper.database;

    List<Map<String, dynamic>> result = await dbClient.query(_table);

    return List.generate(result.length, (index) => TaskModel.fromMap(result[index]));
  }

  Future _onCreate(Database database, int version) async {
    //FIXME: priorityの区分化対応
    await database.execute('''
      CREATE TABLE $_table (
        key TEXT PRIMARY KEY,
        title TEXT,
        description TEXT,
        priority TEXT
      )
      ''');
  }
}