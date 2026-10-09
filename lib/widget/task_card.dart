
import 'package:flutter/material.dart';
import 'package:login_page/model/task_item.dart';

class TaskCard extends StatelessWidget {
  final TaskItem task;
  final ValueChanged<bool> onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const TaskCard({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    const purple = Color(0xFF6257E8);

    final priorityColor = task.priority == 1
        ? Colors.redAccent
        : task.priority == 2
            ? Colors.orange
            : Colors.green;

    return Card(
      color: Colors.white,
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 5,
        ),
        leading: Checkbox(
          value: task.isCompleted,
          activeColor: purple,
          onChanged: (value) => onToggle(value ?? false),
        ),
        title: Text(
          task.title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            decoration: task.isCompleted
                ? TextDecoration.lineThrough
                : TextDecoration.none,
            color: task.isCompleted ? Colors.grey : Colors.black87,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (task.description.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(task.description),
              ),
            const SizedBox(height: 5),
            Wrap(
              spacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(
                  '${task.dueDate.day}/${task.dueDate.month}/${task.dueDate.year}',
                  style: const TextStyle(fontSize: 12),
                ),
                Text(
                  task.priority == 1
                      ? 'High'
                      : task.priority == 2
                          ? 'Medium'
                          : 'Low',
                  style: TextStyle(
                    fontSize: 12,
                    color: priorityColor,
                  ),
                ),
              ],
            ),
            if (task.completedAt != null)
              Text(
                'Completed ${task.completedAt!.day}/'
                '${task.completedAt!.month}/'
                '${task.completedAt!.year}',
                style: const TextStyle(
                  color: Colors.green,
                  fontSize: 11,
                ),
              ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'edit') onEdit();
            if (value == 'delete') onDelete();
          },
          itemBuilder: (_) => const [
            PopupMenuItem(
              value: 'edit',
              child: Text('Edit task'),
            ),
            PopupMenuItem(
              value: 'delete',
              child: Text('Delete task'),
            ),
          ],
        ),
      ),
    );
  }
}
