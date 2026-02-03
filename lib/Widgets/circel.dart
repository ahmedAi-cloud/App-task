import 'package:flutter/material.dart';

class ProgressCircle extends StatelessWidget {
  final double percent;
  final String title;
  final Color color;

  const ProgressCircle({
    super.key,
    required this.percent,
    required this.title,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 140,
              height: 140,
              child: CircularProgressIndicator(
                value: percent,
                strokeWidth: 10,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation(color),
              ),
            ),
            Text(
              "${(percent * 100).toInt()}%",
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
