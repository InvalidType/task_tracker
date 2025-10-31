import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // ← для jsonEncode/jsonDecode
import '../models/task.dart';
import '../widgets/custom_task_form_dialog.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_elevated_button.dart';
import '../widgets/task_card.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  final TextEditingController _controller = TextEditingController();
  String? _errorMessage;
  List<Task> _tasks = [];

  // Категории
  String _selectedCategory = 'Работа';
  final List<String> _categories = ['Работа', 'Личное', 'Учёба'];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final String? jsonString = prefs.getString('tasks');
    if (jsonString != null) {
      final List<dynamic> jsonList = jsonDecode(jsonString) as List<dynamic>;
      final List<Task> tasks = jsonList.map((e) => Task.fromJson(e as Map<String, dynamic>)).toList();
      setState(() {
        _tasks = tasks;
      });
    }
  }

  Future<void> _saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final List<Map<String, dynamic>> jsonList = _tasks.map((task) => task.toJson()).toList();
    final String jsonString = jsonEncode(jsonList);
    await prefs.setString('tasks', jsonString);
  }

  Future<void> _showAddTaskDialog() async {
    final Task? newTask = await showDialog<Task>(context: context, builder: (context) => const TaskFormDialog());

    if (newTask != null) {
      setState(() {
        _tasks.add(newTask);
      });
      _saveTasks();
    }
  }

  void _deleteTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
    _saveTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Мои задачи')),
      body: Column(
        children: [
          Expanded(
            child:
                _tasks.isEmpty
                    ? const Center(child: Text('Список задач пуст'))
                    : ListView.builder(
                      itemCount: _tasks.length,
                      itemBuilder: (context, index) {
                        final task = _tasks[index];
                        return TaskCard(task: _tasks[index], onDelete: () => _deleteTask(index));
                      },
                    ),
          ),
        ],
      ),
      floatingActionButton: CustomElevatedButton(onPressed: _showAddTaskDialog, icon: Icons.add),
    );
  }
}
