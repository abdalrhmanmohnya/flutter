import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:todo/ToDoSql/ToDo.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

late Future <Database>database;
void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  database =openDatabase(
    join(await getDatabasesPath(),'doggie_database.db'),
    onCreate: (db,version){
      return db.execute(
        'CREATE TABLE todos(id INTEGER AUTOINCREMENT PRIMARY KEY,'
            'title TEXT,'
            'description TEXT,'
            'image TEXT,'
            'completed DOUBLE)',
      );
    },
    version: 1,
  );
  var fido = const ToDo (
    id: 1,
   image: '',
    completed:0 ,
    description:'' ,
    title:'' ,
  );
  await ToDo.insertToDo(fido);
  print(await ToDo.todos());
   fido =  ToDo (
    id: 1,
     title: '',
     description:'' ,
     completed: 0,
     image:'' ,
  );
  await ToDo.updateToDo(fido);
  print(await ToDo.todos());
  await ToDo.deleteToDo(fido.id);
  print(await ToDo.todos());
}