import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test/Managers/task_notifer.dart';
import 'package:test/Models/note_model.dart';

class AddTaskScreen extends StatefulWidget {
  final Note? taskToEdit;
  const AddTaskScreen({super.key, this.taskToEdit});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late Note task;
  late TextEditingController titleController;
  late TextEditingController descController;

  final List<String> categories = [
    'Personal',
    'Educational',
    'Work',
    'Health',
    'Gym',
    'Fitness',
    'Family',
    'Other',
  ];

  int currentCategory = -1;

  bool get isEditing => widget.taskToEdit != null;

  @override
  void initState() {
    super.initState();

    if (isEditing) {
      // بنعمل نسخة جديدة من الـ task عشان مانعدلش على الأصلي غصب عن Submit
      final original = widget.taskToEdit!;
      task = Note(
        date: original.date,
        title: original.title,
        desc: original.desc,
        isCompleted: original.isCompleted,
        category: original.category,
      );
      currentCategory = categories.indexOf(original.category);
    } else {
      task = Note(
        date: DateTime.now(),
        title: '',
        desc: '',
        isCompleted: false,
      );
    }

    titleController = TextEditingController(text: task.title);
    descController = TextEditingController(text: task.desc);
  }

  @override
  void dispose() {
    titleController.dispose();
    descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'Edit Task' : 'Add Task')),
      body: Center(
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: titleController,
                  onChanged: (data) {
                    task.title = data;
                  },
                  decoration: const InputDecoration(labelText: 'Task Title'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a task';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                TextFormField(
                  controller: descController,
                  onChanged: (data) {
                    task.desc = data;
                  },
                  decoration: const InputDecoration(labelText: 'Description'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 30),

                const Text('Category', style: TextStyle(fontSize: 20)),

                const SizedBox(height: 10),

                SizedBox(
                  height: 50,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    separatorBuilder: (context, index) {
                      return const SizedBox(width: 10);
                    },
                    itemBuilder: (context, index) {
                      return ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(
                            currentCategory == index
                                ? Colors.blue
                                : Colors.white,
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            currentCategory = index;
                            task.category = categories[index];
                          });
                        },
                        child: Text(
                          categories[index],
                          style: TextStyle(
                            color: currentCategory == index
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 20),

                // Shows a validation message if no category is picked yet.
                if (currentCategory == -1)
                  const Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Text(
                      'Please select a category',
                      style: TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),

                Center(
                  child: Consumer<TaskNotifer>(
                    builder: (context, taskNotifer, child) {
                      return ElevatedButton(
                        onPressed: () {
                          final isFormValid = formKey.currentState!.validate();
                          if (isFormValid && currentCategory != -1) {
                            if (isEditing) {
                              taskNotifer.editTask(widget.taskToEdit!, task);
                            } else {
                              taskNotifer.addTask(task);
                            }
                            Navigator.pop(context);
                          } else if (currentCategory == -1) {
                            setState(() {}); // triggers the category warning
                          }
                        },
                        child: Text(isEditing ? 'Save' : 'Submit'),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
