class Task {
  final String title; // описание задачи и ее же название (в будущем мб разделю мб нет)
  final String category; // категория задачи

  Task(this.title, this.category);

  // Преобразует объект в JSON-совместимый Map
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'category': category,
    };
  }

  // Создаёт объект из JSON
  static Task fromJson(Map<String, dynamic> json) {
    return Task(
      json['title'] as String,
      json['category'] as String,
    );
  }
}