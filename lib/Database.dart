import 'package:taskmanagement/Tasks.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class TasksController {
  Future<void> saveTasks(List<Task> tasks) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String tasksJson = jsonEncode(tasks.map((task) => task.toJson()).toList());
    await prefs.setString('tasks', tasksJson);
  }

  Future<List<Task>> loadTasks() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? tasksJson = prefs.getString('tasks');
    if (tasksJson != null) {
      final List<dynamic> tasksList = jsonDecode(tasksJson);
      return tasksList.map((json) => Task.fromJson(json)).toList();
    } else {
      return [];
    }
  }

}
