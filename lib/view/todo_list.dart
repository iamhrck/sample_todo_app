import 'package:flutter/material.dart';
import 'package:sample_todo_app/model/task_model.dart';

class MyListView extends StatelessWidget {
  MyListView({super.key});

  // リストに表示するテキストアイテムのデータ
  final List<TaskModel> _list = [
    TaskModel(key: "1", description: "永福町オリーブ歯科", title: "歯医者", priority: Priority.high),
    TaskModel(key: "2", description: "方南町", title: "インフルエンザ予防接種", priority: Priority.high),
    TaskModel(key: "3", description: "残り7万ぐらい", title: "ふるさと納税"),
  ];

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
        itemCount: _list.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: _list[index].getPriorityIcon(),
            /**
            三項演算子（Dartでいう条件演算子）は`??`を使う
             */
            title: Text(_list[index].title ?? ""),
            subtitle: Text(_list[index].description ?? ""),
            onTap: () {},
          );
        },
      ),
    );
  }
}