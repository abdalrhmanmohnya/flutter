import 'dart:io';
import 'package:flutter/material.dart';
import 'package:todo/ToDoSql/ToDoClass.dart';
import 'package:todo/main.dart';
class DetailScreen extends StatelessWidget {
  int index;
   DetailScreen({super.key,required this.index});
  @override
  Widget build(BuildContext context) {
    Color cardColor = CompletedCardColor(ToDo.todos[index].completed);
    return
      Scaffold(
        appBar: AppBar(
          title: Text('description'),
        ),
        body:
        IntrinsicHeight(
            child: Card(
          color: cardColor,
          margin: EdgeInsets.all(20),
          elevation: 10,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
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
                            style: TextStyle(color: Colors.black54),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 5, 0, 5),
                    child:
                    Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      Text('Description: ',style: TextStyle(fontSize: 20), ),
                      ConstrainedBox(child: Text(ToDo.todos[index].description, style: TextStyle(color: Colors.black54)),
                        constraints: BoxConstraints(maxWidth: 200, maxHeight: double.infinity),
                      ),

                    ],),

                  ),
                ],
              ),
              Column(//  mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 15, 10, 15),
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
            ],
          ),
        ))
                );
  }
}
