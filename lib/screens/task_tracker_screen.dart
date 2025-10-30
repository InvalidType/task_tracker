import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // ← для jsonEncode/jsonDecode
import '../models/task.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_elevated_button.dart';

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
      final List<Task> tasks = jsonList
          .map((e) => Task.fromJson(e as Map<String, dynamic>))
          .toList();
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

  void _addTask() {
    final text = _controller.text.trim();
    if (text.isEmpty) {
      setState(() {
        _errorMessage = 'Введите задачу';
      });
      return;
    }

    setState(() {
      _errorMessage = null;
      _tasks.add(Task(text, _selectedCategory));
    });

    _controller.clear();
    _saveTasks();
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: DropdownButtonFormField<String>(
              value: _selectedCategory,
              items: _categories.map((category) {
                return DropdownMenuItem(value: category, child: Text(category));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value!;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Категория',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: CustomTextField(
              controller: _controller,
              hintText: 'Введите задачу',
              errorText: _errorMessage,
              onSubmitted: (value) => _addTask(),
            ),
          ),
          Expanded(
            child: _tasks.isEmpty
                ? const Center(child: Text('Список задач пуст'))
                : ListView.builder(
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                final task = _tasks[index];
                return ListTile(
                  title: Text(task.title),
                  subtitle: Text(task.category),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteTask(index),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: CustomElevatedButton(
        onPressed: _addTask,
        icon: Icons.add,
      ),
    );
  }
}