
import 'package:flutter/material.dart';
import 'package:login_page/model/task_item.dart';


class TaskEditorDialog extends StatefulWidget {
  final TaskItem? task;
  final DateTime initialDate;

  const TaskEditorDialog({
    super.key,
    this.task,
    required this.initialDate,
  });

  @override
  State<TaskEditorDialog> createState() =>
      _TaskEditorDialogState();
}

class _TaskEditorDialogState extends State<TaskEditorDialog> {
  late final TextEditingController titleController;
  late final TextEditingController descriptionController;

  late DateTime dueDate;
  late int priority;

  @override
  void initState() {
    super.initState();

    titleController = TextEditingController(
      text: widget.task?.title ?? '',
    );
    descriptionController = TextEditingController(
      text: widget.task?.description ?? '',
    );

    dueDate = widget.task?.dueDate ?? widget.initialDate;
    priority = widget.task?.priority ?? 2;
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  String formatDate(DateTime date) =>
      '${date.day}/${date.month}/${date.year}';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.task == null ? 'New task' : 'Edit task'),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              autofocus: true,
              maxLength: 100,
              decoration: const InputDecoration(
                labelText: 'Task title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: descriptionController,
              maxLines: 3,
              maxLength: 500,
              decoration: const InputDecoration(
                labelText: 'Description (optional)',
                border: OutlineInputBorder(),
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(
                Icons.calendar_month,
                color: Color(0xFF6257E8),
              ),
              title: const Text('Due date'),
              subtitle: Text(formatDate(dueDate)),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: dueDate,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2100),
                );

                if (picked != null) {
                  setState(() => dueDate = picked);
                }
              },
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<int>(
              value: priority,
              decoration: const InputDecoration(
                labelText: 'Priority',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 1, child: Text('High')),
                DropdownMenuItem(value: 2, child: Text('Medium')),
                DropdownMenuItem(value: 3, child: Text('Low')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() => priority = value);
                }
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFF6257E8),
          ),
          onPressed: () {
            final title = titleController.text.trim();

            if (title.isEmpty) return;

            final result = TaskItem(
              title: title,
              description: descriptionController.text.trim(),
              dueDate: dueDate,
              priority: priority,
              isCompleted: widget.task?.isCompleted ?? false,
              completedAt: widget.task?.completedAt,
            );

            Navigator.pop(context, result);
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
