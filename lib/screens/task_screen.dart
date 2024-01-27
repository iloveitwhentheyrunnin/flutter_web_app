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
  final TextEditingController _titreController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  late DateTime _selectedDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mes tâches'),
      ),
      body: FutureBuilder<List<TaskModel>>(
        future: taskService.fetchTasks(),
        builder: (context, snapshot) {
          if (snapshot.hasData &&
              snapshot.data != null &&
              snapshot.data!.isNotEmpty) {
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
                            "Titre: ${task.titre}" ?? 'No titre',
                            style: TextStyle(
                              decoration: task.isDone ?? false
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  "Description: ${task.description}" ??
                                  'No Description'),
                              Text(
                                  "Créee le: ${task.createdAt != null ? dateFormat.format(task.createdAt!) : 'No Created At'}"),
                              Text(
                                  "Pour le: ${dateFormat.format(task.dueDate!.toLocal())}" ??
                                      'No Due At'),
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
                                  task.isDone = value!;
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
                'Aucunes tâches pour le moment.',
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          showModalBottomSheet(
            context: context,
            builder: (BuildContext bc) {
              return MyCustomForm(
                onCreateTask: (TaskModel newTask) async {
                  try {
                    // call service vers api pour créer
                    TaskModel createdTask =
                        await taskService.createTask(newTask);
                    print('Created task: $createdTask');

                    // call api pour fetch
                    List<TaskModel> updatedTasks =
                        await taskService.fetchTasks();
                    print('Updated tasks: $updatedTasks');

                    // mise a jour de l'état pour afficher
                    setState(() {
                      updatedTasks;
                    });
                  } catch (error) {
                    print('Error creating task: $error');
                  }
                },
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class MyCustomForm extends StatefulWidget {
  final Function(TaskModel) onCreateTask;

  const MyCustomForm({Key? key, required this.onCreateTask}) : super(key: key);

  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

class MyCustomFormState extends State<MyCustomForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titreController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  late DateTime _selectedDate;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextFormField(
              controller: _titreController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Merci de renseigner un titre';
                }
                return null;
              },
              decoration: const InputDecoration(
                hintText: 'Titre',
              ),
            ),
            TextFormField(
              controller: _descriptionController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Merci de renseigner une description';
                }
                return null;
              },
              decoration: const InputDecoration(
                hintText: 'Description',
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  // Validation passed, proceed to create the task
                  String titre = _titreController.text;
                  String description = _descriptionController.text;

                  // Optionally, show a date picker here for due date
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(9999),
                  );

                  if (pickedDate != null) {
                    setState(() {
                      _selectedDate = pickedDate.toLocal();
                    });
                  }

                  // Now, you have titre, description, and selected date to create the task
                  TaskModel newTask = TaskModel(
                    titre: titre,
                    description: description,
                    createdAt: DateTime.now(),
                    dueDate: _selectedDate,
                    isDone: false,
                  );

                  // Call the callback to create the task in the parent widget
                  widget.onCreateTask(newTask);

                  // Close the bottom sheet
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Créer ma tâche'),
            ),
          ],
        ),
      ),
    );
  }
}
