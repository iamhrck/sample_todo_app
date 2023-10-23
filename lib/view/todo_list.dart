import 'package:flutter/material.dart';
import 'package:sample_todo_app/model/task_model.dart';

class MyListView extends StatelessWidget {
  const MyListView({super.key, required this.tasks});

  // リストに表示するテキストアイテムのデータ
  final List<TaskModel> tasks;

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
          return ListTile(
            leading: tasks[index].getPriorityIcon(),
            /**
            三項演算子（Dartでいう条件演算子）は`??`を使う
             */
            title: Text(tasks[index].title ?? ""),
            subtitle: Text(tasks[index].description ?? ""),
            onTap: () {},
          );
        },
      ),
    );
  }
}