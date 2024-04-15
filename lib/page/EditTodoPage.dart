import 'dart:io';
import 'package:flutter/material.dart';
import 'package:todo/ToDoSql/ToDoClass.dart';
import 'package:todo/main.dart';
import 'package:image_picker/image_picker.dart';

class EiditTodoPage extends StatefulWidget {
  final int index;
  EiditTodoPage({super.key, required this.index});

  @override
  State<EiditTodoPage> createState() => _EiditTodoPageState(index);
}

class _EiditTodoPageState extends State<EiditTodoPage> {
  bool isDataEdited = false;
  final int index;
  _EiditTodoPageState(this.index);
  late TextEditingController EditTitleController;
  late TextEditingController EditDescriptionController;
  XFile? Editimage;
  double? SliderCompletedValue;
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    EditTitleController = TextEditingController(text: ToDo.todos[index].title);
    EditDescriptionController = TextEditingController(text: ToDo.todos[index].description);
    Editimage = ToDo.todos[index].image;
    SliderCompletedValue = ToDo.todos[index].completed;
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Add Todo Page'),
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 60, 0, 40),
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        child: CircleAvatar(
                          radius: 70,
                          backgroundImage: Editimage == null
                              ? AssetImage('image/4.png')
                              : FileImage(File(Editimage!.path))
                                  as ImageProvider,
                        ),
                      ), //Container
                      Positioned(
                          left: 10,
                          top: 100,
                          child: IconButton(
                              icon: Icon(Icons.add_circle, size: 35),
                              onPressed: () async {
                                ImagePicker _picker = new ImagePicker();
                                final img = await _picker.pickImage(
                                    source: ImageSource.gallery);
                                setState(() {
                                  Editimage = img;
                                  isDataEdited = true;
                                });
                              }))
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                  child: TextFormField(
                    onChanged: (String value) {
                      setState(() {
                        isDataEdited = true;
                      });
                    },
                    controller: EditTitleController,
                    enabled: true,
                    style: TextStyle(fontSize: 16, color: Colors.blue),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(),
                      hintText: "Enter Title",
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter Title';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                  child: TextFormField(
                    onChanged: (String value) {
                      setState(() {
                        isDataEdited = true;
                      });
                    },
                    controller: EditDescriptionController,
                    enabled: true,
                    style: TextStyle(fontSize: 16, color: Colors.blue),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(),
                      hintText: "Enter Description",
                    ),
                    maxLines: null,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please Enter The Description';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                    child: ElevatedButton(
                      onPressed: isDataEdited
                          ? ()  async {
                        if (_formKey.currentState!.validate()) {

                            final UpdateTodo = ToDo(
                              ToDo.todos[index].id,
                              EditTitleController.text,
                              EditDescriptionController.text,
                              Editimage!,
                              SliderCompletedValue!,
                            );
                            await ToDo.updateToDo(UpdateTodo);
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => ToDosScreen(),
                              ),
                            );

                        }
                      }
                          : null,
                      child: Text(
                        'Edit',
                        style: TextStyle(color: Colors.orange.shade900),
                      ),
                    )),
              ],
            ),
          ),
        ));
  }
}
