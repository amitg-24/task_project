
import 'package:flutter/material.dart';
import 'package:login_page/model/task_item.dart';
import 'task_card.dart';
import 'empty_state.dart';

class TaskCalendar extends StatelessWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateChanged;
  final List<TaskItem> tasks;
  final ValueChanged<TaskItem> onEdit;
  final ValueChanged<TaskItem> onDelete;
  final void Function(TaskItem, bool) onToggle;

  const TaskCalendar({
    super.key,
    required this.selectedDate,
    required this.onDateChanged,
    required this.tasks,
    required this.onEdit,
    required this.onDelete,
    required this.onToggle,
  });

  bool sameDay(DateTime a, DateTime b) =>
      a.year == b.year &&
      a.month == b.month &&
      a.day == b.day;

  @override
  Widget build(BuildContext context) {
    final dailyTasks = tasks
        .where((task) => sameDay(task.dueDate, selectedDate))
        .toList();

    return ListView(
      padding: const EdgeInsets.only(top: 18, bottom: 24),
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: CalendarDatePicker(
            initialDate: selectedDate,
            firstDate: DateTime(2020),
            lastDate: DateTime(2100),
            onDateChanged: onDateChanged,
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(top: 22, bottom: 12),
          child: Text(
            'Tasks for selected date',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        if (dailyTasks.isEmpty)
          const SizedBox(
            height: 160,
            child: EmptyState(
              title: 'No tasks for this date',
              subtitle: 'Choose another date or add a task.',
              icon: Icons.event_available_outlined,
            ),
          ),
        ...dailyTasks.map(
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
