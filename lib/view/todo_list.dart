import 'package:flutter/material.dart';
import 'package:sample_todo_app/model/task_model.dart';
import 'package:sample_todo_app/utils/db_helper.dart';

class MyListView extends StatelessWidget {
  const MyListView({super.key, required this.tasks});

  // リストに表示するテキストアイテムのデータ
  final List<TaskModel> tasks;

  void deleteTodo(TaskModel task, BuildContext context) {
    if (task.key == null) {
      return;
    }

    DBHelper().deleteTodo(task.key!).then((_) => {
      ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text('item is deleted'),
          backgroundColor: Colors.red,
        )
      )
    });
    
  }

  @override
  Widget build(BuildContext context) {
    /*
    ExpandedというWidgetは、RowやColumnの子Widget間の隙間を目一杯埋めたいときに使う
    Composeでいうところのweight
    */
    return Expanded(
      /*
      スクロール可能なウィジェットのリスト、一覧作成とかで利用する
      デフォルトコンストラクタ：リストの要素数がimmutableの場合
      ListView.builder：実際に表示されている子要素のみビルダーが呼び出される
      　　　　　　　　　　 随時読み込みなど、多数(または無限)のリストを表示する場合に利用する作成方法です。



      */
      child: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];
          return Dismissible(
            direction: DismissDirection.horizontal,
            dismissThresholds: const {
              DismissDirection.startToEnd: 0,
              DismissDirection.endToStart: 0.5,
            },
            /*
            key: Key("$index"),としていると以下のエラーが発生
            A dismissed Dismissible widget is still part of the tree
            Dismissibleにバインドされる要素のキーは一位になるようにしようというもの
            */
            key: ObjectKey(task.key),
            onDismissed:(direction) => {
              if (direction == DismissDirection.endToStart && task.key != null) {
                deleteTodo(task, context)
              }
            },
            background: Container(color: Colors.red),
            child: ListTile(
              leading: task.getPriorityIcon(),
              /**
              三項演算子（Dartでいう条件演算子）は`??`を使う
              */
              title: Text(task.title ?? ""),
              subtitle: Text(task.description ?? ""),
              onTap: () {},
            )
          );
        },
      ),
    );
  }
}