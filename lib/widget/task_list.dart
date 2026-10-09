
import 'package:flutter/material.dart';
import 'package:login_page/model/task_item.dart';
import 'task_card.dart';
import 'empty_state.dart';

class TaskList extends StatelessWidget {
  final List<TaskItem> tasks;
  final ValueChanged<TaskItem> onToggle;
  final ValueChanged<TaskItem> onEdit;
  final ValueChanged<TaskItem> onDelete;

  const TaskList({
    super.key,
    required this.tasks,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) {
      return const EmptyState(
        title: 'No tasks found',
        subtitle: 'Tap + to create your first task',
      );
    }

    return ListView(
      padding: const EdgeInsets.only(top: 18, bottom: 24),
      children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                'Your tasks',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Text(
              '${tasks.length} tasks',
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...tasks.map(
          (task) => TaskCard(
            task: task,
            onToggle: (value) => onToggle(task),
            onEdit: () => onEdit(task),
            onDelete: () => onDelete(task),
          ),
        ),
      ],
    );
  }
}
