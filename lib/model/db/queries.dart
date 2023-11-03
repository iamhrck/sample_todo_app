import 'package:sample_todo_app/model/db/definition.dart';

const createTasksTable = '''
  CREATE TABLE $table (
      key INTEGER PRIMARY KEY AUTOINCREMENT, 
      title TEXT,
      description TEXT,
      priority TEXT
);
''';

/*
schema version 1 to 2
$tableの主キーをTEXTからINTEGER(AUTOINCREMENT)に変換するマイグレーション
sqfliteのALTER TABLEは既存カラムの定義変更に対応していないので
新規テーブル作成→データ移行→旧テーブル削除という流れで行う
 */
const migration1To2 = [
  'ALTER TABLE $table RENAME TO tmp;',
  createTasksTable,
  '''
    INSERT INTO $table(title, description, priority)
      SELECT title, description, priority
      FROM tmp;
  ''',
  'DROP TABLE tmp;'
];
