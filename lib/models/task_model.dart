class TaskModel {
  int? id;
  String? title;
  String? description;
  DateTime? createdAt;
  DateTime? dueDate;
  bool? isDone;

  TaskModel({
    this.id,
    this.title,
    this.description,
    this.createdAt,
    this.dueDate,
    this.isDone,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'],
      title: json['titre'],
      description: json['description'],
      createdAt: DateTime.parse(json['created_at']),
      dueDate: DateTime.parse(json['due_date']),
      isDone: json['is_done'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titre': title,
      'description': description,
      'created_at': createdAt?.toIso8601String(),
      'due_date': dueDate?.toIso8601String(),
      'is_done': isDone,
    };
  }

  // Setters
  set setId(int? value) {
    id = value;
  }

  set setTitle(String? value) {
    title = value;
  }

  set setDescription(String? value) {
    description = value;
  }

  set setCreatedAt(DateTime? value) {
    createdAt = value;
  }

  set setDueDate(DateTime? value) {
    dueDate = value;
  }

  set setIsDone(bool? value) {
    isDone = value;
  }
}
