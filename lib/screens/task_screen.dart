import 'package:api_rest_front/constants/colors.dart';
import 'package:api_rest_front/models/task_model.dart';
import 'package:api_rest_front/services/task_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


// création de mon écran
class TaskScreen extends StatefulWidget {
  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  final TaskService taskService = TaskService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task List'),
      ),
      body: FutureBuilder<List<TaskModel>>(
        future: taskService.fetchTasks(),
        builder: (context, snapshot) {
          // Vérification de la présence de données
          if (snapshot.hasData && snapshot.data != null && snapshot.data!.isNotEmpty) {
            List<TaskModel> tasks = snapshot.data!;
            return ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                TaskModel task = tasks[index];

                // Formattage de ma date en fr
                final DateFormat dateFormat = DateFormat.yMMMMd('fr_FR');

                return Card(
                  color: tdBGColor,
                  margin: EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(
                      "Titre: ${task.title}" ?? 'No Title',
                      style: TextStyle(
                        decoration: task.isDone ?? false ? TextDecoration.lineThrough : TextDecoration.none,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Description: ${task.description}" ?? 'No Description'),
                        Text("Créee le: ${dateFormat.format(task.createdAt!)}" ?? 'No Created At'),
                        Text("Pour le: ${dateFormat.format(task.dueDate!)}" ?? 'No Due At'),
                      ],
                    ),
                    trailing: Checkbox(
                      value: task.isDone ?? false,
                      onChanged: (value) {
                        // TODO - toggle le bool is_done
                      },
                    ),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
          } else {
              return Center(
                child: Text('Aucunes tâches pour le moment, on prend des vacances? :)',
                style: TextStyle(fontSize: 25), textAlign: TextAlign.center,),
              );
          }
        },
      ),
    );
  }
}
