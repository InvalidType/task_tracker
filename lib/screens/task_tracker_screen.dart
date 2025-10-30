import 'package:flutter/material.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_elevated_button.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  final List<String> _tasks = []; // список задач
  final TextEditingController _controller = TextEditingController();

  void _addTask() {
    if (_controller.text.trim().isNotEmpty) {
      setState(() {
        _tasks.add(_controller.text.trim());
        _controller.clear();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Мои задачи')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: CustomTextField(
              controller: _controller,
              hintText: 'Введите задачу',
              onSubmitted: (value) => _addTask(),
            ),
          ),
          Expanded(
            child: _tasks.isEmpty
                ? const Center(child: Text('Список задач пуст'))
                : ListView.builder(
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_tasks[index]),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      setState(() {
                        _tasks.removeAt(index);
                      });
                    },
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