import 'package:flutter/material.dart';
import '../models/task.dart';

class TaskList extends StatelessWidget {
  final List<Task> tasks;
  final Function(Task) onToggle;
  final Function(Task) onDelete;

  const TaskList({
    super.key,
    required this.tasks,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) {
      return const Expanded(
        child: Center(child: Text("مفيش مهام لسه")),
      );
    }

    return Expanded(
      child: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];

          return Dismissible(
            key: ValueKey(task.id),
            direction: DismissDirection.endToStart,
            background: Container(
              padding: const EdgeInsets.only(right: 20),
              alignment: Alignment.centerRight,
              color: Colors.red,
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            onDismissed: (_) => onDelete(task),
            child: Card(
              margin: const EdgeInsets.symmetric(vertical: 6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: CheckboxListTile(
                value: task.isDone,
                onChanged: (_) => onToggle(task),
                title: Text(
                  task.title,
                  style: TextStyle(
                    decoration: task.isDone
                        ? TextDecoration.lineThrough
                        : null,
                  ),
                ),
                controlAffinity:
                    ListTileControlAffinity.leading,
              ),
            ),
          );
        },
      ),
    );
  }
}
