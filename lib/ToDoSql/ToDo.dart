import 'package:sqflite/sqflite.dart';
import 'ToDoTestSql.dart';

class ToDo {
  final int id;
  final String title,description,image;
  final double completed;

  const ToDo({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.completed,
  });
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'image': image,
      'completed': completed,
    };
  }

  @override
  String toString() {
    return 'ToDo{id:$id,title:$title,description:$description,image:$image,completed:$completed}';
  }

  static Future<void> insertToDo(ToDo todo) async {
    final db = await database;
    await db.insert(
      'todos',
      todo.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<ToDo>> todos() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('todos');
    return List.generate(maps.length, (i) {
      return ToDo(
        id: maps[i]['id'] as int,
        title: maps[i]['title'] as String,
        description: maps[i]['description'] as String,
        image: maps[i]['image'] as String,
        completed: maps[i]['completed'] as double,
      );
    });
  }

  static Future<void> updateToDo(ToDo todo) async {
    final db = await database;
    await db.update(
      'todos',
      todo.toMap(),
      where: 'id = ?',
      whereArgs: [todo.id],
    );
  }
  static Future<void> deleteToDo(int id) async {
    final db = await database;
    await db.delete(
      'todos',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
