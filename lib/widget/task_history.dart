
import 'package:flutter/material.dart';
import 'package:login_page/model/task_item.dart';
import 'task_card.dart';
import 'empty_state.dart';

class TaskHistory extends StatelessWidget {
  final List<TaskItem> tasks;
  final ValueChanged<TaskItem> onEdit;
  final ValueChanged<TaskItem> onDelete;
  final void Function(TaskItem, bool) onToggle;

  const TaskHistory({
    super.key,
    required this.tasks,
    required this.onEdit,
    required this.onDelete,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final completedTasks = tasks
        .where((task) => task.isCompleted)
        .toList()
      ..sort(
        (a, b) => (b.completedAt ?? b.dueDate)
            .compareTo(a.completedAt ?? a.dueDate),
      );

    if (completedTasks.isEmpty) {
      return const EmptyState(
        title: 'No completed tasks',
        subtitle: 'Completed tasks will appear here.',
        icon: Icons.history_rounded,
      );
    }

    return ListView(
      padding: const EdgeInsets.only(top: 18, bottom: 24),
      children: [
        Text(
          'Completed tasks (${completedTasks.length})',
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        ...completedTasks.map(
          (task) => TaskCard(
            task: task,
            onEdit: () => onEdit(task),
            onDelete: () => onDelete(task),
            onToggle: (value) => onToggle(task, value),
          ),
        ),
      ],
    );
  }
}
