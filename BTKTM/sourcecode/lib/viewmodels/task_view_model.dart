import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../data/database_helper.dart';

class TaskViewModel extends ChangeNotifier {
  List<Task> _tasks = [];
  List<Task> get tasks => _tasks;

  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<void> loadTasks() async {
    _tasks = await _dbHelper.getTasks();
    notifyListeners();
  }

  Future<void> addTask(String title, String description) async {
    final newTask = Task(title: title, description: description);
    await _dbHelper.insertTask(newTask);
    await loadTasks();
  }

  Future<void> deleteTask(int id) async {
    _tasks.removeWhere((task) => task.id == id);
    notifyListeners();

    await _dbHelper.deleteTask(id);
  }
}
