import 'package:image_picker/image_picker.dart';
import 'package:sqflite/sqflite.dart';

import '../main.dart';

class ToDo {
  int? id;
  String title, description;
  XFile? image;
  double completed;
  static List<ToDo> todos = [];
  ToDo(this.id, this.title, this.description, this.image, this.completed);
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'image': image!.path,
      'completed': completed,
    };
  }

  @override
  String toString() {
    return 'ToDo{title:$title,description:$description,image:$image,completed:$completed}';
  }

  static Future<void> insertToDo(ToDo todo) async {
    final db = await database;
    await db.insert(
      'Todo',
      todo.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    ToDo.todos=await ToDo.getAlltodos();
  }

  static Future<void> updateToDo(ToDo todo) async {
    final db = await database;
    await db.update(
      'Todo',
      todo.toMap(),
      where: 'id = ?',
      whereArgs: [todo.id],
    );
    ToDo.todos=await ToDo.getAlltodos();
  }

  static Future<void> deleteToDo(int index) async {
    final db = await database;
    await db.delete(
      'Todo',
      where: 'id = ?',
      whereArgs: [index],
    );
    ToDo.todos=await ToDo.getAlltodos();
  }

  static Future<List<ToDo>> getAlltodos() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('Todo');
    return List.generate(maps.length, (i) {
      return ToDo(
        maps[i]['id'] as int,
        maps[i]['title'] as String,
        maps[i]['description'] as String,
        XFile(maps[i]['image'] as String),
        maps[i]['completed'] as double,
      );
    });
  }
}
