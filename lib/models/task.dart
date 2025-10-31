class Task {
  final String title; // название задачи
  final String category; // категория задачи
  final DateTime? dueDate; // срок выполнения задачи может быть null

  Task(this.title, this.category, {this.dueDate});

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'category': category,
      'dueDate': dueDate?.toIso8601String(), // DateTime → String
    };
  }

  static Task fromJson(Map<String, dynamic> json) {
    final dueDateString = json['dueDate'] as String?;
    return Task(
      json['title'] as String,
      json['category'] as String,
      dueDate: dueDateString != null ? DateTime.parse(dueDateString) : null,
    );
  }
}