import 'package:flutter/material.dart';

class MyTab extends StatelessWidget {
  final String iconPath;
  final String tabName;
  const MyTab({super.key, required this.iconPath, required this.tabName});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Tab(
          height: 80,
          child: Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border(),
                color: Colors.grey[200], borderRadius: BorderRadius.circular(12)),
            child: Image.asset(
              iconPath,
              color: Colors.grey[600],
            ),
          ),
        ),
        Text(
          tabName,
          style: const TextStyle(fontSize: 10),
        ),
        const SizedBox(height: 5,)
      ],
    );
  }
}
