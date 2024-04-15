import 'dart:io';
import 'package:flutter/material.dart';
import 'package:todo/page/AddTodoPage.dart';
import 'package:todo/page/DeleteTodo.dart';
import 'package:todo/page/DetailScreen.dart';
import 'package:todo/page/EditTodoPage.dart';
import 'package:todo/ToDoSql/ToDoClass.dart';
import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

late Future<Database> database;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  database = openDatabase(
    join(await getDatabasesPath(), 'MyDataBase.db'),
    // to mske auto increment by hand we use max(id) +1
    // to optimize we use auto increment when we create table
    onCreate: (db, version) {
      return db.execute(
        'CREATE TABLE Todo(id INTEGER PRIMARY KEY AUTOINCREMENT,'
        'title TEXT,'
        'description TEXT,'
        'image TEXT,'
        'completed DOUBLE)',
      );
    },
    version: 1,
  );
  runApp(MaterialApp(
    home: ToDosScreen(),
  ));
}

class ToDosScreen extends StatefulWidget {
  @override
  State<ToDosScreen> createState() => _ToDosScreenPageState();
}

class _ToDosScreenPageState extends State<ToDosScreen> {
  getTodos() async {
    ToDo.todos = await ToDo.getAlltodos();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getTodos();
    print('in=${ToDo.todos.length}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('ToDos Screen Page'),
          actions: [
            TextButton.icon(
              label: Text('Add Todo',
                  style: TextStyle(color: Colors.orange.shade900)),
              icon: Icon(Icons.add_comment, color: Colors.orange.shade900),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => AddTodoPage()),
                )
                ;
              },
            ),
            IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DeleteTodosPage()),
                  );
                  setState(()  {  });
                },
                icon: Icon(Icons.delete))
          ],
        ),
        body: ToDo.todos.isEmpty
            ? Center(
                child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('The Todos list is empty !',
                      style: TextStyle(
                          fontSize: 30, color: Colors.orange.shade900)),
                  Text(' Please click the Add Todo button to enter a Todo.',
                      style: TextStyle(fontSize: 16))
                ],
              ))
            : Container(
                child: ListView.builder(
                    itemCount: ToDo.todos.length,
                    itemBuilder: (context, index) {
                      Color cardColor = CompletedCardColor(ToDo.todos[index].completed);
                      return
                       GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DetailScreen(
                                        index: index,
                                      )));
                        },
                        child: 
                        Card(
                          color: cardColor,
                          margin: EdgeInsets.all(20),
                          elevation: 10,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  IconButton(
                                    onPressed: ()async {
                                     await ToDo.deleteToDo(ToDo.todos[index].id!);
                                      setState(() {});
                                    },
                                    icon: Icon(Icons.close),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return EiditTodoPage(index: index);
                                          },
                                        ),
                                      ).then((UpdateTodo) {
                                        if (UpdateTodo != null) {
                                          setState(() {});
                                        }
                                      });
                                    },
                                    icon: Icon(Icons.edit),
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(20, 15, 0, 5),
                                    child: Text.rich(
                                      TextSpan(
                                        children: [
                                          TextSpan(
                                            text: 'Title: ',
                                            style: TextStyle(fontSize: 20),
                                          ),
                                          TextSpan(
                                            text: ToDo.todos[index].title,
                                            style: TextStyle(
                                                color: Colors.black54),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Slider(
                                    value: ToDo.todos[index].completed,
                                    max: 100,
                                    min: 0,
                                    divisions: 2,
                                    label:
                                        '${(ToDo.todos[index].completed).toInt()}%',
                                    onChanged: (double value) async {
                                      setState(() {
                                        ToDo.todos[index].completed = value;
                                      });
                                      final updatedSlider = ToDo(
                                        ToDo.todos[index].id,
                                        ToDo.todos[index].title,
                                        ToDo.todos[index].description,
                                        ToDo.todos[index].image,
                                        value.toDouble(),
                                      );
                                      await ToDo.updateToDo(updatedSlider);
                                    },
                                  ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.all(10),
                                child: Center(
                                  child: CircleAvatar(
                                    radius: 50,
                                    backgroundImage: FileImage(
                                        File(ToDo.todos[index].image!.path)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    })
        ));
  }
}

Color CompletedCardColor(double value) {
  if (value < 50) {
    return Colors.red.shade200;
  } else if (value < 100) {
    return Colors.yellow.shade300;
  } else {
    return Colors.green.shade300;
  }
}
