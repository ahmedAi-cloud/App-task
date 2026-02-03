import 'package:flutter/material.dart';

class TaskInput extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onAddTask;

  const TaskInput({
    super.key,
    required this.controller,
    required this.onAddTask,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                decoration: const InputDecoration(
                  hintText: "اكتب مهمة جديدة",
                  border: InputBorder.none,
                ),
                onSubmitted: (value) {
                  _submit();
                },
              ),
            ),
            IconButton(
              icon: const Icon(Icons.add_circle, size: 32),
              color: Colors.blue,
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }

  void _submit() {
    final text = controller.text.trim();
    if (text.isEmpty) return;

    onAddTask(text); // 🔥 Firebase هيشتغل هنا
    controller.clear();
  }
}
