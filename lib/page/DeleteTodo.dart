import 'package:flutter/material.dart';
import 'package:todo/ToDoSql/ToDoClass.dart';
import 'package:todo/main.dart';

class DeleteTodosPage extends StatefulWidget {
  //final int index;
  const DeleteTodosPage({super.key,
    //required this.index
  });

  @override
  State<DeleteTodosPage> createState() => _DeleteTodosPageState(
   // index
  );
}

class _DeleteTodosPageState extends State<DeleteTodosPage> {
 // final int index;
 // _DeleteTodosPageState(this.index);
  int? dropdownTodo = ToDo.todos.length == 0 ? 0 : ToDo.todos[0].id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Delete'),
      ),
      body: Center(
          child: DropdownButton<int>(
        value: dropdownTodo,
        icon: Icon(Icons.arrow_downward),
        elevation: 30,
        onChanged: (int? value) {
          setState(() {
            dropdownTodo = value!;
            print(dropdownTodo);
          });
        },
        items: ToDo.todos.isEmpty
            ? [
                DropdownMenuItem<int>(
                  value:dropdownTodo ,
                  child: Text("There are no Todos to delete"),
                ),
              ]
            : ToDo.todos.map<DropdownMenuItem<int>>((ToDo value) {
                return DropdownMenuItem<int>(
                  value: value.id,
                  child: Text(value.title),
                  onTap: () async{
                     // ToDo.deleteToDo(ToDo.todos[index].id!);
                      await ToDo.deleteToDo(dropdownTodo!);
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => ToDosScreen(),
                        ),
                      );
                    //  Navigator.pop(context);
                      setState(()  {  });
                  },
                );
              }).toList(),
      )),
    );
  }
}
