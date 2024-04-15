import 'dart:io';
import 'package:flutter/material.dart';
import 'package:todo/ToDoSql/ToDoClass.dart';
import 'package:todo/main.dart';
import 'package:image_picker/image_picker.dart';

class AddTodoPage extends StatefulWidget {
  const AddTodoPage({Key? key}) : super(key: key);
  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  TextEditingController TitleController = new TextEditingController();
  TextEditingController DescriptionController = new TextEditingController();
  XFile? image;
  double SliderCompletedValue = 0;
  final _formKey = GlobalKey<FormState>();
  @override
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
                          backgroundImage: image == null
                              ? AssetImage('image/4.png')
                              : FileImage(File(image!.path)) as ImageProvider,
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
                                  image = img;
                                });
                              }))
                    ], //<Widget>[]
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                  child: TextFormField(
                    controller: TitleController,
                    enabled: true,
                    style: TextStyle(fontSize: 16, color: Colors.blue),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(),
                      hintText: "Enter Title",
                      // suffixIcon: Icon(Icons.lock),
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
                    controller: DescriptionController,
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
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          if (image == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Center(
                                    child: Text(
                                  'Please enter an image',
                                  style: TextStyle(color: Colors.black),
                                )),
                                backgroundColor: Colors.black12,
                              ),
                            );
                          } else {
                            ToDo newTodo = ToDo(
                              null,
                              TitleController.text,
                              DescriptionController.text,
                              image!,
                              SliderCompletedValue,
                            );
                          await  ToDo.insertToDo(newTodo);
                            Navigator.of(context).pushReplacement(MaterialPageRoute(
                                    builder: (context) => ToDosScreen()));
                            setState(() {});
                          }
                        }
                      },
                      child: Text(
                        'Add',
                        style: TextStyle(color: Colors.orange.shade900),
                      )),
                ),
              ],
            ),
          ),
        ));
  }
}
