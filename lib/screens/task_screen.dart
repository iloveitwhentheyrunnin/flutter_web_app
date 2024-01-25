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
        title: Text('Mes tâches'),
      ),
      body: FutureBuilder<List<TaskModel>>(
        future: taskService.fetchTasks(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null && snapshot.data!.isNotEmpty) {
            List<TaskModel> tasks = snapshot.data!;

            return SingleChildScrollView(
              child: Center(
                child: Column(
                  children: tasks.map((TaskModel task) {
                    final DateFormat dateFormat = DateFormat.yMMMMd('fr_FR');

                    return Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      margin: EdgeInsets.all(8.0),
                      child: Card(
                        color: tdBGColor,
                        child: ListTile(
                          title: Text(
                            "Titre: ${task.title}" ?? 'No Title',
                            style: TextStyle(
                              decoration: task.isDone ?? false ? TextDecoration.lineThrough : TextDecoration.none,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Description: ${task.description}" ?? 'No Description'),
                              Text("Créee le: ${dateFormat.format(task.createdAt!)}" ?? 'No Created At'),
                              Text("Pour le: ${dateFormat.format(task.dueDate!)}" ??'No Due At'),
                            ElevatedButton(
                                child: const Text('Supprimer'),
                                onPressed: () async {
                                  try {
                                    await taskService.deleteTask(task);
                                    setState(() {
                                      tasks.remove(task);
                                    });
                                  } catch (error) {
                                    print('Error deleting task: $error');
                                  }
                                },
                              ),
                            ],
                          ),
                          trailing: Checkbox(
                            value: task.isDone ?? false,
                            onChanged: (value) async {
                              try {
                                setState(() {
                                  task.isDone = value;
                                });
                                await taskService.updateTask(task);
                              } catch (error) {
                                setState(() {
                                  task.isDone = !value!;
                                });
                                print('Error updating task: $error');
                              }
                            },
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            return const Center(
              child: Text(
                'Aucunes tâches pour le moment, on prend des vacances? :)',
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
            );
          }
        },
      ),
    );
  }
}
