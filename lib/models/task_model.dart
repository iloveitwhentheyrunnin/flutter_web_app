class TaskModel {
  int? id;
  String titre;
  String description;
  DateTime createdAt;
  DateTime dueDate;
  bool isDone;

  TaskModel({
    this.id,
    required this.titre,
    required this.description,
    required this.createdAt,
    required this.dueDate,
    required this.isDone,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
  return TaskModel(
    id: json['id'],
    titre: json['titre'],
    description: json['description'],
    createdAt: DateTime.parse(json['created_at'].toString()),
    dueDate: DateTime.parse(json['due_date'].toString()),
    isDone: json['is_done'],
  );
}

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titre': titre,
      'description': description,
      'created_at': createdAt, // Convert DateTime to string
      'due_date': dueDate, // Convert DateTime to string
      'is_done': isDone,
    };
  }

  // Setters
  set setId(int? value) {
    id = value;
  }

  set setTitle(String value) {
    titre = value;
  }

  set setDescription(String value) {
    description = value;
  }

  set setCreatedAt(DateTime value) {
    createdAt = value;
  }

  set setDueDate(DateTime value) {
    dueDate = value;
  }

  set setIsDone(bool value) {
    isDone = value;
  }
}
