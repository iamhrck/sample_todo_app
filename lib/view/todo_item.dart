import 'package:flutter/widgets.dart';

class SampleAppCounterLeadMessage extends StatelessWidget {
  // コンポーネントには必須
  const SampleAppCounterLeadMessage({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const Text(
      'Sample Component'
      );
  }
}

class TodoItem extends StatelessWidget {
  const TodoItem({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const Text(
      'あいうえお'
      );
  }
}