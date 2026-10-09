
import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;
  final VoidCallback onAddPressed;

  const BottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
    required this.onAddPressed,
  });

  @override
  Widget build(BuildContext context) {
    const purple = Color(0xFF6257E8);

    return SafeArea(
      top: false,
      child: Container(
        height: 76,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(18),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.10),
              blurRadius: 12,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  onPressed: () => onItemTapped(0),
                  icon: Icon(
                    Icons.format_list_bulleted_rounded,
                    color: selectedIndex == 0
                        ? purple
                        : Colors.grey.shade400,
                  ),
                ),
                const SizedBox(width: 65),
                IconButton(
                  onPressed: () => onItemTapped(1),
                  icon: Icon(
                    Icons.calendar_today_outlined,
                    color: selectedIndex == 1
                        ? purple
                        : Colors.grey.shade400,
                  ),
                ),
              ],
            ),
            Positioned(
              top: -17,
              child: FloatingActionButton(
                heroTag: 'addTaskButton',
                onPressed: onAddPressed,
                backgroundColor: purple,
                shape: const CircleBorder(),
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
