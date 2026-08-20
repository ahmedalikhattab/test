import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test/Models/note_model.dart';

class TaskNotifer extends ChangeNotifier {
  List<Note> alltasks = [];

  static const String _storageKey = 'tasks';

  TaskNotifer() {
    loadTasks(); 
  }

  Future<void> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final tasksJson = prefs.getStringList(_storageKey) ?? [];

    alltasks = tasksJson
        .map((taskString) => Note.fromMap(jsonDecode(taskString)))
        .toList();

    notifyListeners();
  }

  Future<void> _saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final tasksJson = alltasks
        .map((task) => jsonEncode(task.toMap()))
        .toList();

    await prefs.setStringList(_storageKey, tasksJson);
  }

  void addTask(Note task) {
    alltasks.add(task);
    notifyListeners();
    _saveTasks();
  }

  void toggleComplete(Note task) {
    task.isCompleted = !task.isCompleted;
    notifyListeners();
    _saveTasks();
  }

  void removeTask(Note task) {
    alltasks.remove(task);
    notifyListeners();
    _saveTasks();
  }

  void editTask(Note oldTask, Note updatedTask) {
    final index = alltasks.indexOf(oldTask);
    if (index != -1) {
      alltasks[index] = updatedTask;
      notifyListeners();
      _saveTasks();
    }
  }
}