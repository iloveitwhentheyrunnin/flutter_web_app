import 'dart:convert';
import 'package:api_rest_front/models/task_model.dart';
import 'package:http/http.dart' as http;

class TaskService {
  final String apiUrl = 'http://127.0.0.1:8000/api/tasks';

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


}
