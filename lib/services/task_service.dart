import 'dart:convert';
import 'package:api_rest_front/models/task_model.dart';
import 'package:http/http.dart' as http;

class TaskService {
  final String apiUrl = 'http://127.0.0.1:8000/api/tasks';

  // method to get my tasks
  Future<List<TaskModel>> fetchTasks() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        // Extract the list of tasks from "hydra:member"
        final List<dynamic> data = responseData['hydra:member'];

        final List<TaskModel> tasks =
            data.map((taskJson) => TaskModel.fromJson(taskJson)).toList();

        // Log the result to the console
        print('Fetched ${tasks.length} tasks: $tasks');

        return tasks;
      } else {
        // Log the error to the console
        print('Failed to load tasks. Status code: ${response.statusCode}');
        throw Exception('Failed to load tasks');
      }
    } catch (error) {
      // Log any other errors to the console
      print('Error: $error');
      throw Exception('Failed to load tasks');
    }
  }

  // method to update my task
  Future<void> updateTask(TaskModel task) async {
    try {
      final response = await http.patch(
        Uri.parse('$apiUrl/${task.id}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'is_done': task.isDone}),
      );

      if (response.statusCode == 200) {
        print('Task updated successfully: $task');
      } else {
        print('Failed to update task. Status code: ${response.statusCode}');
        throw Exception('Failed to update task');
      }
    } catch (error) {
      print('Error updating task: $error');
      throw Exception('Error updating task');
    }
  }

  //method to create my task!
  Future<TaskModel> createTask(TaskModel newTask) async {
    try {
      final response = await http.post(
        Uri.parse('$apiUrl/create'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'titre': newTask.title,
          'description': newTask.description,
          'createdAt': DateTime.now(),
          'dueDate': newTask.dueDate,
          'isDone': false,
        }),
      );

      if (response.statusCode == 201) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final TaskModel createdTask = TaskModel.fromJson(responseData);

        print('Task created successfully: $createdTask');

        return createdTask;
      } else {
        print('Failed to create task. Status code: ${response.statusCode}');
        throw Exception('Failed to create task');
      }
    } catch (error) {
      print('Error creating task: $error');
      throw Exception('Error creating task');
    }
  }

  //method to delete my task
  Future<void> deleteTask(TaskModel task) async {
  try {
    final response = await http.delete(
      Uri.parse('$apiUrl/delete/${task.id}'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 204) {
      // La suppression côté serveur est réussie, pas de données à renvoyer
      return;
    } else {
      print('Failed to delete task. Status code: ${response.statusCode}');
      throw Exception('Failed to delete task');
    }
  } catch (error) {
    print('Error deleting task: $error');
    throw Exception('Error deleting task');
  }
}

}
