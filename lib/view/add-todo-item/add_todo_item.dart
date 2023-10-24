
import 'package:flutter/cupertino.dart';
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
      body: const AddTodoItemContent()
    );
  }
}

class AddTodoItemContent extends StatefulWidget {
  const AddTodoItemContent({super.key});

  @override
  State<StatefulWidget> createState() => _AddTodoItemContentState();
}

class _AddTodoItemContentState extends State<AddTodoItemContent> {
  final taskTitleController = TextEditingController();
  final taskDescriptionController = TextEditingController();
  final DBHelper db = DBHelper();

  void clearButtonClick() {
    taskTitleController.text = "";
    taskDescriptionController.text = "";
  }

  Future<void> addButtonClick(BuildContext context) async {
    TaskModel task = TaskModel(
      description: taskDescriptionController.text,
      title: taskTitleController.text
    );
    bool result = await db.insert(task);

    /**
     * https://dart.dev/tools/linter-rules/use_build_context_synchronously
     * 
     * Don't use 'BuildContext's across async gaps. Try rewriting the code to not reference the 'BuildContext'
     */
    if (!mounted) return;

    if (result) {
      print("success");
      Navigator.pop(context, result);
    } else {
      print("failure");
    }
  }

  // void _showFailureDialog(BuildContext context) {
  //   showCupertinoModalPopup<void>(
  //     context: context,
  //     builder: (BuildContext context) => CupertinoAlertDialog(
  //       title: const Text('しばらく経ってから再度お試しください'),
  //       content: const Text('Proceed with destructive action?'),
  //       actions: <CupertinoDialogAction>[
  //         CupertinoDialogAction(
  //           isDestructiveAction: true,
  //           onPressed: () {
  //             Navigator.pop(context);
  //           },
  //           child: const Text('OK'),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(64),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
            Row(
              children: [
                const Expanded(
                  flex: 1,
                  child: Text("title"),
                ),
                const SizedBox(width: 32),
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: taskTitleController,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
             Row(
              children: [
                const Expanded(
                  flex: 1,
                  child: Text("description"),
                ),
                const SizedBox(width: 32),
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: taskDescriptionController,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              TextButton(
                onPressed: clearButtonClick,
                child: const Text('Clear',style: TextStyle(color: Colors.black),),
              ),
                const SizedBox(width: 64),
                TextButton(
                  onPressed: () {
                    addButtonClick(context);
                  }, 
                  child: const Text("add")
                ),
              ],
            )
        ],
      )
    );
  }
}