
import 'package:flutter/material.dart';
import 'package:sample_todo_app/model/task_model.dart';
import 'package:sample_todo_app/utils/db_helper.dart';

class AddTodoItemPage extends StatelessWidget {
  const AddTodoItemPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("TODO追加"),
      ),
      body: AddTodoItemContent()
    );
  }

}

class AddTodoItemContent extends StatelessWidget {
  // コンポーネントには必須
  AddTodoItemContent({super.key});

  final DBHelper db = DBHelper();

  void cancelButtonClick(BuildContext context) {
    Navigator.of(context).pop();
  }

  void addButtonClick() {
    var model = TaskModel(description: "description", title: "title", priority: Priority.high);
    db.insert(model);
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(64),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
            const Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Text("title"),
                ),
                SizedBox(width: 32),
                Expanded(
                  flex: 2,
                  child: TextField(),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Text("description"),
                ),
                SizedBox(width: 32),
                Expanded(
                  flex: 2,
                  child: TextField(),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              TextButton(
                onPressed: () {
                  cancelButtonClick(context);
                },
                child: const Text('Cancel',style: TextStyle(color: Colors.black),),
              ),
                const SizedBox(width: 64),
                TextButton(
                  onPressed: addButtonClick, 
                  child: const Text("add")
                ),
              ],
            )
        ],
      )
    );
  }
}