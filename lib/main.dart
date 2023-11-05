import 'package:flutter/material.dart';
import 'package:sample_todo_app/model/task_model.dart';
import 'package:sample_todo_app/utils/constants.dart';
import 'package:sample_todo_app/utils/db_helper.dart';
import 'package:sample_todo_app/view/add-todo-item/add_todo_item.dart';
import 'package:sample_todo_app/view/todo_item.dart';
import 'package:sample_todo_app/view/todo_list.dart';

void main() async {
  // これなに
  WidgetsFlutterBinding.ensureInitialized(); 

  await DBHelper().init();

  runApp(const TodoApp());
}

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appTitle,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const TodoListPage(title: appTitle),
    );
  }
}

// StatefulWidgetを消す
class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key, required this.title});

  final String title;

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  bool _isLoading = true;
  
  List<TaskModel> _list = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    // ここで非同期処理
    List<TaskModel> tasks = await DBHelper().getTasks();

    setState(() {
      _isLoading = false;
      _list = _list + tasks;
    });
  }


  Future<void> _navigateAddPageAndReload(BuildContext context) async {
    final bool result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddTodoItemPage()),
    );

    // いたる処理の中で状態をいじってるのがキモい
    setState(() {
      _isLoading = true;
      _list = [];
    });

    if (result) {
      await _loadData();
    }

    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text('new item is added'),
          backgroundColor: Colors.green,
        )
      );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const CircularProgressIndicator();
    } else {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title)
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SampleAppCounterLeadMessage(),
              MyListView(tasks: _list),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _navigateAddPageAndReload(context);
          },
          tooltip: 'Increment',
          child: const Icon(Icons.add),
        ), 
      );
    }
  }
}
