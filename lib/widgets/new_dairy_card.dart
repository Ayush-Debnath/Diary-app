import 'package:flutter/material.dart';

class NewDiaryCard extends StatelessWidget {
  final VoidCallback onTap;

  const NewDiaryCard({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        // Design your new diary card with add button icon here
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(
          Icons.add,
          size: 50,
          color: Colors.grey,
        ),
      ),
    );
  }
}
