
// ---------------- Logo (purple box with tick) ----------------
import 'package:flutter/material.dart';
import 'package:login_page/main.dart';

class Logo extends StatelessWidget {
  const Logo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: purple,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Icon(Icons.check, color: Colors.white, size: 50),
    );
  }
}
