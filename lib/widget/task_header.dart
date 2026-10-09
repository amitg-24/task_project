
import 'package:flutter/material.dart';

class TaskHeader extends StatelessWidget {
  final int selectedIndex;
  final DateTime selectedDate;
  final TextEditingController searchController;
  final ValueChanged<String> onSearch;
  final ValueChanged<String> onMenuSelected;

  const TaskHeader({
    super.key,
    required this.selectedIndex,
    required this.selectedDate,
    required this.searchController,
    required this.onSearch,
    required this.onMenuSelected,
  });

  String formatDate(DateTime date) =>
      '${date.day}/${date.month}/${date.year}';

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 125,
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF9995FF), Color(0xFF7778F2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.grid_view_rounded,
                color: Colors.white,
                size: 21,
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Container(
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: TextField(
                    controller: searchController,
                    onChanged: onSearch,
                    style: const TextStyle(fontSize: 12),
                    decoration: const InputDecoration(
                      hintText: 'Search',
                      prefixIcon: Icon(
                        Icons.search,
                        size: 12,
                        color: Colors.grey,
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 5),
                      border: InputBorder.none,
                      isDense: true,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              PopupMenuButton<String>(
                padding: EdgeInsets.zero,
                icon: const Icon(
                  Icons.more_horiz,
                  color: Colors.white,
                ),
                onSelected: onMenuSelected,
                itemBuilder: (_) => const [
                  PopupMenuItem(value: 'all', child: Text('All tasks')),
                  PopupMenuItem(
                    value: 'pending',
                    child: Text('Pending tasks'),
                  ),
                  PopupMenuItem(
                    value: 'completed',
                    child: Text('Completed tasks'),
                  ),
                  PopupMenuItem(
                    value: 'history',
                    child: Text('Task history'),
                  ),
                ],
              ),
            ],
          ),
          const Spacer(),
          Text(
            selectedIndex == 1
                ? 'Selected · ${formatDate(selectedDate)}'
                : selectedIndex == 2
                    ? 'Your completed tasks'
                    : 'Today, ${formatDate(DateTime.now())}',
            style: const TextStyle(
              color: Color(0xFFE2E1FF),
              fontSize: 10,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            selectedIndex == 1
                ? 'Calendar'
                : selectedIndex == 2
                    ? 'Task history'
                    : 'My tasks',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
