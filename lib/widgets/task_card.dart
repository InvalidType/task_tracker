import 'package:flutter/material.dart';
import '../models/task.dart';

// представление карточки в виде класса
class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onDelete;

  const TaskCard({
    super.key,
    required this.task,
    required this.onDelete,
  });

  // Цвета для категорий
  Color _getCategoryColor() {
    switch (task.category) {
      case 'Работа':
        return Colors.blue;
      case 'Личное':
        return Colors.green;
      case 'Учёба':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  // представление карточки как виджета
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          width: 8,
          decoration: BoxDecoration(
            color: _getCategoryColor(),
            borderRadius: const BorderRadius.horizontal(right: Radius.circular(4)),
          ),
        ),
        title: Text(
          task.title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              task.dueDate != null
                  ? '${task.category} • ${task.dueDate!.toLocal().day}.${task.dueDate!.toLocal().month}.${task.dueDate!.toLocal().year}'
                  : task.category,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.redAccent),
          onPressed: onDelete,
        ),
      ),
    );
  }
}