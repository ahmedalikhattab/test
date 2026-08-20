import 'package:flutter/material.dart';
import 'package:test/Managers/task_notifer.dart';
import 'package:test/screens/Home_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const NotesApp());
}

class NotesApp extends StatefulWidget {
  const NotesApp({super.key});

  @override
  State<NotesApp> createState() => _NotesAppState();
}

class _NotesAppState extends State<NotesApp> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TaskNotifer(),
      child: MaterialApp(home: const HomeScreen()));
  }
}
