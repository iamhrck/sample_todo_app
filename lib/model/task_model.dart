
import 'package:flutter/material.dart';

class TaskModel {
  int? key;
  String? title;
  String? description;
  Priority? priority;

  TaskModel(
      { 
        this.key,
        required this.description,
        required this.title,
        this.priority
      }
  );

  Icon getPriorityIcon() {
  switch (priority) {
      case Priority.high:
        return const Icon(Icons.priority_high);
      case Priority.middle:
        return const Icon(Icons.info);
      case Priority.low:
        return const Icon(Icons.low_priority);
      default:
        return const Icon(Icons.help);
    }
  }

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      key: map['key'],
      description: map['description'],
      title: map['title'],
      priority: Priority.high
    );
  }

}

enum Priority {
  high,
  middle,
  low;
}