class Task {
  String id;
  String title;
  bool isDone;

  Task({
    required this.id,
    required this.title,
    required this.isDone,
  });

  factory Task.fromMap(String id, Map<String, dynamic> data) {
    return Task(
      id: id,
      title: data['title'],
      isDone: data['isDone'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'isDone': isDone,
      'createdAt': DateTime.now(),
    };
  }
}
