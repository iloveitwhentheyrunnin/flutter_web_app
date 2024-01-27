import 'package:api_rest_front/constants/colors.dart';
import 'package:api_rest_front/models/task_model.dart';
import 'package:api_rest_front/services/task_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
        title: Text('Mes tâches', style: TextStyle(color: Colors.white)),
        backgroundColor: tdBGColor,
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
                      margin: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: const Color.fromARGB(255, 173, 173, 173).withOpacity(.9),
                            blurRadius: 14.0, // soften the shadow
                            spreadRadius: 0.0, //extend the shadow
                            offset: const Offset(
                              0.0, // Move to right 10  horizontally
                              6.0, // Move to bottom 10 Vertically
                            ),
                          )
                        ],
                      ),
                      child: Card(
                        color: tdBGColor,
                        child: ListTile(
                          title: Text(
                            "Titre: ${task.titre}",
                            style: TextStyle(
                              color: Colors.white,
                              decoration: task.isDone
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                              decorationColor:
                                  task.isDone ? Colors.white : null,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Description: ${task.description}",
                                style: const TextStyle(color: Colors.white),
                              ),
                              Text(
                                "Créee le: ${dateFormat.format(task.createdAt)}",
                                style: const TextStyle(color: Colors.white),
                              ),
                              Text(
                                "Pour le: ${dateFormat.format(task.dueDate.toLocal())}",
                                style: const TextStyle(color: Colors.white),
                              ),
                              SizedBox(height: 20.0),
                              Row(
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.delete,
                                      color: tdBGColor,
                                    ),
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
                                  const SizedBox(width:10.0), // Adjust the width as needed
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.edit,
                                      color: tdBGColor,
                                    ),
                                    onPressed: () async {
                                      _titreController.text = task.titre;
                                      _descriptionController.text = task.description;
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              scrollable: true,
                                              title: const Text('Modifier'),
                                              content: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Form(
                                                  child: Column(
                                                    children: <Widget>[
                                                      TextFormField(
                                                        cursorColor: tdBGColor,
                                                        controller: _titreController,
                                                        decoration: const InputDecoration(
                                                          labelText: 'Titre',
                                                          labelStyle: TextStyle(color: tdBGColor),
                                                          icon: Icon(Icons.title),
                                                          focusedBorder: UnderlineInputBorder(
                                                            borderSide: BorderSide(color: Colors.black), // Change the border color
                                                          ),
                                                        ),
                                                      ),
                                                      TextFormField(
                                                        cursorColor: tdBGColor,
                                                        controller: _descriptionController,
                                                        decoration: const InputDecoration(
                                                          labelText: 'Description',
                                                          labelStyle: TextStyle(color: tdBGColor),
                                                          icon: Icon(Icons.message),
                                                          focusedBorder: UnderlineInputBorder(
                                                            borderSide: BorderSide(color: Colors.black), // Change the border color
                                                          ),
                                                        ),
                                                      ),
                                                    ],

                                                  ),
                                                ),
                                              ),
                                              shape:
                                                  const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10))),
                                              actions: [
                                                ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor: tdBGColor,
                                                  ),
                                                    child: const Text("Confirmer", style: TextStyle(color: Colors.white),),
                                                    onPressed: () async {
                                                      String newTitle = _titreController.text;
                                                      String newDescription = _descriptionController.text;
                                                        try {
                                                          await taskService.editTask(task, newTitle, newDescription );
                                                          setState(() {
                                                            Navigator.of(context).pop();
                                                          });
                                                        } catch (error) {
                                                          print('Error editing task: $error');
                                                        }
                                                    })
                                              ],
                                            );
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),

                          trailing: Checkbox(
                            side: const BorderSide(color: Colors.white, width: 2),
                            value: task.isDone,
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
                            activeColor: tdBGColor,
                            checkColor: Colors.white,
                            fillColor:
                                MaterialStateProperty.resolveWith<Color?>(
                              (Set<MaterialState> states) {
                                if (states.contains(MaterialState.selected)) {
                                  // Retourne la couleur de fond lorsque la case à cocher est sélectionnée.
                                  return tdBGColor; // Couleur de fond noire
                                }
                                // Sinon, retourne null, ce qui utilise la couleur par défaut.
                                return null;
                              },
                            ),
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
              child: Text('Error: ${snapshot.error}',
                  style: const TextStyle(color: tdBGColor)),
            );
          } else {
            return const Center(
              child: Text(
                'Aucunes tâches pour le moment.',
                style: TextStyle(fontSize: 20, color: tdBGColor),
                textAlign: TextAlign.center,
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: tdBGColor,
        onPressed: () async {
          showModalBottomSheet(
            context: context,
            builder: (BuildContext bc) {
              return MyCustomForm(
                onCreateTask: (TaskModel newTask) async {
                  try {
                    TaskModel createdTask =
                        await taskService.createTask(newTask);
                    print('Created task: $createdTask');

                    List<TaskModel> updatedTasks =
                        await taskService.fetchTasks();
                    print('Updated tasks: $updatedTasks');

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
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
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
      margin: const EdgeInsets.only(bottom: 100.0), // Ajoutez la marge en haut de 20.0 pixels (ajustez selon vos besoins)
      padding: const EdgeInsets.all(30.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextFormField(
              cursorColor: tdBGColor,
              controller: _titreController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Merci de renseigner un titre';
                }
                return null;
              },
              decoration: const InputDecoration(
                labelText: 'Titre',
                labelStyle: TextStyle(color: tdBGColor),
                focusedBorder:OutlineInputBorder(
                  borderSide: BorderSide(color: Color.fromARGB(255, 0, 0, 0), width: 1.0),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              cursorColor: tdBGColor,
              controller: _descriptionController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Merci de renseigner une description';
                }
                return null;
              },
              decoration: const InputDecoration(
                floatingLabelStyle: TextStyle(color: tdBGColor),
                labelText: 'Description',
                labelStyle: TextStyle(color: tdBGColor),
                focusedBorder:OutlineInputBorder(
                  borderSide: BorderSide(color: Color.fromARGB(255, 0, 0, 0), width: 1.0),
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            SizedBox(
              width: 100.0,
              child: ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    String titre = _titreController.text;
                    String description = _descriptionController.text;

                    DateTime? pickedDate = await showDatePicker(
                      barrierColor: Color.fromARGB(48, 0, 0, 0).withOpacity(0.6),
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(9999),
                        builder: (BuildContext context, Widget? child) {
                          return Theme(
                            data: ThemeData.light().copyWith(
                              primaryColor:
                                  tdBGColor,
                              colorScheme:
                                  const ColorScheme.light(primary: tdBGColor),
                              buttonTheme: const ButtonThemeData(
                                  textTheme: ButtonTextTheme.primary),
                            ),
                            child: child!,
                          );
                        });

                    if (pickedDate != null) {
                      setState(() {
                        _selectedDate = pickedDate.toLocal();
                      });
                    }

                    TaskModel newTask = TaskModel(
                      titre: titre,
                      description: description,
                      createdAt: DateTime.now(),
                      dueDate: _selectedDate,
                      isDone: false,
                    );

                    widget.onCreateTask(newTask);

                    Navigator.of(context).pop();
                  }
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: tdBGColor,
                    elevation: 5,
                    shadowColor: tdBGColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    ),
                child: const Text(
                  'Créer ma tâche',
                  style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
