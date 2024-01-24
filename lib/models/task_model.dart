// lib/models/task_model.dart

class TaskModel {
  final int? id;
  final String? title;
  final String? description;
  final DateTime? createdAt;
  final DateTime? dueDate;
  final bool? isDone;

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
}
