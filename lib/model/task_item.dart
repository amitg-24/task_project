
class TaskItem {
  String? id;
  String title;
  String description;
  DateTime dueDate;
  DateTime? completedAt;
  bool isCompleted;
  int priority;

  TaskItem({
    this.id,
    required this.title,
    this.description = '',
    required this.dueDate,
    this.isCompleted = false,
    this.priority = 2,
    this.completedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'dueDate': dueDate.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'isCompleted': isCompleted,
      'priority': priority,
    };
  }

  factory TaskItem.fromMap(
    Map<String, dynamic> map, {
    String? id,
  }) {
    return TaskItem(
      id: id,
      title: map['title'] as String? ?? '',
      description: map['description'] as String? ?? '',
      dueDate: DateTime.tryParse(
            map['dueDate'] as String? ?? '',
          ) ??
          DateTime.now(),
      completedAt: DateTime.tryParse(
        map['completedAt'] as String? ?? '',
      ),
      isCompleted: map['isCompleted'] as bool? ?? false,
      priority: map['priority'] as int? ?? 2,
    );
  }
}
