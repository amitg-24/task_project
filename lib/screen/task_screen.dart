
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:login_page/model/task_item.dart';
import 'package:login_page/widget/bottom_nav_bar.dart';
import 'package:login_page/widget/empty_state.dart';
import 'package:login_page/widget/task_calender.dart';
import 'package:login_page/widget/task_card.dart';
import 'package:login_page/widget/task_editor_dialog.dart';
import 'package:login_page/widget/task_header.dart';
import 'package:login_page/widget/task_history.dart';

enum TaskFilter { all, pending, completed }

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  final searchController = TextEditingController();
  final List<TaskItem> tasks = [];

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>?
      taskSubscription;

  int selectedIndex = 0;
  TaskFilter filter = TaskFilter.all;
  DateTime selectedDate = DateTime.now();

  bool isLoadingTasks = true;
  String? taskLoadError;

  CollectionReference<Map<String, dynamic>> get taskCollection {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      throw StateError('Please log in first.');
    }

    return FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('tasks');
  }

  @override
  void initState() {
    super.initState();
    listenToTasks();
  }

  void listenToTasks() {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      setState(() {
        isLoadingTasks = false;
        taskLoadError = 'Please log in to view your tasks.';
      });
      return;
    }

    taskSubscription = taskCollection.snapshots().listen(
      (snapshot) {
        if (!mounted) return;

        setState(() {
          tasks
            ..clear()
            ..addAll(
              snapshot.docs.map(
                (doc) => TaskItem.fromMap(
                  doc.data(),
                  id: doc.id,
                ),
              ),
            );

          isLoadingTasks = false;
          taskLoadError = null;
        });
      },
      onError: (Object error) {
        if (!mounted) return;

        setState(() {
          isLoadingTasks = false;
          taskLoadError =
              'Could not load tasks. Check your Firebase rules.';
        });

        debugPrint('Firestore task loading error: $error');
      },
    );
  }

  List<TaskItem> get filteredTasks {
    final query = searchController.text.trim().toLowerCase();

    return tasks.where((task) {
      final matchesSearch =
          task.title.toLowerCase().contains(query) ||
          task.description.toLowerCase().contains(query);

      final matchesFilter = switch (filter) {
        TaskFilter.all => true,
        TaskFilter.pending => !task.isCompleted,
        TaskFilter.completed => task.isCompleted,
      };

      return matchesSearch && matchesFilter;
    }).toList()
      ..sort((a, b) => a.dueDate.compareTo(b.dueDate));
  }

  @override
  void dispose() {
    taskSubscription?.cancel();
    searchController.dispose();
    super.dispose();
  }

  void showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  // ADD TASK / EDIT TASK
  Future<void> editTask({TaskItem? task}) async {
    final result = await showDialog<TaskItem>(
      context: context,
      builder: (_) => TaskEditorDialog(
        task: task,
        initialDate: selectedDate,
      ),
    );

    if (result == null || !mounted) return;

    try {
      if (task == null) {
        // Add a new task to Firestore.
        await taskCollection.add(result.toMap());
        showMessage('Task added successfully.');
      } else {
        // Update the existing Firestore document.
        final id = task.id;

        if (id == null) {
          throw StateError('Task ID is missing.');
        }

        await taskCollection.doc(id).update(result.toMap());
        showMessage('Task updated successfully.');
      }
    } catch (e) {
      debugPrint('Save task error: $e');
      showMessage('Could not save task. Please try again.');
    }
  }

  // DELETE TASK
  Future<void> deleteTask(TaskItem task) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete task?'),
        content: Text('Delete "${task.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            style: FilledButton.styleFrom(
              backgroundColor: Colors.redAccent,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    try {
      final id = task.id;

      if (id == null) {
        throw StateError('Task ID is missing.');
      }

      await taskCollection.doc(id).delete();
      showMessage('Task deleted successfully.');
    } catch (e) {
      debugPrint('Delete task error: $e');
      showMessage('Could not delete task. Please try again.');
    }
  }

  // COMPLETE / PENDING
  Future<void> toggleTask(
    TaskItem task,
    bool completed,
  ) async {
    try {
      final id = task.id;

      if (id == null) {
        throw StateError('Task ID is missing.');
      }

      await taskCollection.doc(id).update({
        'isCompleted': completed,
        'completedAt': completed
            ? DateTime.now().toIso8601String()
            : null,
      });

      showMessage(
        completed ? 'Task completed.' : 'Task marked as pending.',
      );
    } catch (e) {
      debugPrint('Update task status error: $e');
      showMessage('Could not update task status.');
    }
  }

  // FILTER MENU
  void selectMenu(String value) {
    setState(() {
      switch (value) {
        case 'all':
          filter = TaskFilter.all;
          selectedIndex = 0;
          break;

        case 'pending':
          filter = TaskFilter.pending;
          selectedIndex = 0;
          break;

        case 'completed':
          filter = TaskFilter.completed;
          selectedIndex = 0;
          break;

        case 'history':
          selectedIndex = 2;
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final items = filteredTasks;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F4FF),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(9),
          child: Column(
            children: [
              TaskHeader(
                selectedIndex: selectedIndex,
                selectedDate: selectedDate,
                searchController: searchController,
                onSearch: (_) => setState(() {}),
                onMenuSelected: selectMenu,
              ),

              Expanded(
                child: isLoadingTasks
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : taskLoadError != null
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    taskLoadError!,
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 12),
                                  ElevatedButton(
                                    onPressed: () {
                                      taskSubscription?.cancel();

                                      setState(() {
                                        isLoadingTasks = true;
                                        taskLoadError = null;
                                      });

                                      listenToTasks();
                                    },
                                    child: const Text('Retry'),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : buildSelectedPage(items),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: selectedIndex,
        onItemTapped: (index) {
          setState(() => selectedIndex = index);
        },
        onAddPressed: () => editTask(),
      ),
    );
  }

  Widget buildSelectedPage(List<TaskItem> items) {
    switch (selectedIndex) {
      case 1:
        return TaskCalendar(
          selectedDate: selectedDate,
          onDateChanged: (date) {
            setState(() => selectedDate = date);
          },
          tasks: items,
          onEdit: (task) => editTask(task: task),
          onDelete: deleteTask,
          onToggle: toggleTask,
        );

      case 2:
        return TaskHistory(
          tasks: items,
          onEdit: (task) => editTask(task: task),
          onDelete: deleteTask,
          onToggle: toggleTask,
        );

      default:
        return buildTaskList(items);
    }
  }

  Widget buildTaskList(List<TaskItem> items) {
    if (items.isEmpty) {
      return const EmptyState(
        title: 'No tasks found',
        subtitle: 'Tap + to create your first task.',
      );
    }

    return ListView(
      padding: const EdgeInsets.only(top: 18, bottom: 24),
      children: [
        Text(
          'Your tasks (${items.length})',
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        ...items.map(
          (task) => TaskCard(
            task: task,
            onEdit: () => editTask(task: task),
            onDelete: () => deleteTask(task),
            onToggle: (value) => toggleTask(task, value),
          ),
        ),
      ],
    );
  }
}
