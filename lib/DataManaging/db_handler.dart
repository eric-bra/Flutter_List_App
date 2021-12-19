import 'package:listapp/model/todo.dart';
import 'package:listapp/model/todo_list.dart';
import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbHandler {
  static final DbHandler instance = DbHandler._init();

  static Database? _db;

  DbHandler._init();

  Future<Database> get database async {
    if (_db != null) return _db!;

    _db = await _initDB();
    return _db!;
  }

  Future<Database> _initDB() async {
    return await openDatabase(
      join(await getDatabasesPath(), 'todo_database.db'),
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE todos(id INTEGER PRIMARY KEY, content TEXT, checked Integer, list_id Integer)',
        );
        return db.execute(
          'CREATE TABLE todolists(id INTEGER PRIMARY KEY, name TEXT)',
        );
      },
      version: 1,
    );
  }

  static final DbHandler _inst = DbHandler._internal();
  DbHandler._internal();

  factory DbHandler() => _inst;

  Future<List<ToDo>> todos() async {
    // Get a reference to the database.
    final db = await instance.database;

    final List<Map<String, dynamic>> maps = await db.query('todos');

    return List.generate(maps.length, (i) {
      return ToDo(
        id: maps[i]['id'],
        content: maps[i]['content'],
        checked: (maps[i]['checked'] == 1) ? true : false,
        listId: maps[i]['list_id'],
      );
    });
  }

  Future<List<ToDoList>> todoLists() async {
    // Get a reference to the database.
    final db = await instance.database;

    final List<Map<String, dynamic>> maps = await db.query('todolists');

    return List.generate(maps.length, (i) {
      return ToDoList(
        id: maps[i]['id'],
        name: maps[i]['name'],
      );
    });
  }

  Future<List<ToDo>> todosByList(int listId) async {
    // Get a reference to the database.
    final db = await instance.database;

    final List<Map<String, dynamic>> maps = await db.query('todos',
        where:'list_id = ?',
        whereArgs: [listId] );

    return List.generate(maps.length, (i) {
      return ToDo(
        id: maps[i]['id'],
        content: maps[i]['content'],
        checked: (maps[i]['checked'] == 1) ? true : false,
        listId: maps[i]['list_id'],
      );
    });
  }

  Future<void> insertTodo(String name, int listId) async {
    ToDo toDo = ToDo(
        content: name,
        checked: false,
        id: DateTime.now().millisecondsSinceEpoch,
        listId: listId);
    final db = await instance.database;
    await db.insert(
      'todos',
      toDo.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
  Future<void> insertTodoList(String name, int listId) async {
    ToDoList list = ToDoList(
        name: name,
        id: DateTime.now().millisecondsSinceEpoch,);
    final db = await instance.database;
    await db.insert(
      'todolists',
      list.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> update(bool newValue, int id) async {
    final db = await instance.database;
    await db.update(
      'todos',
      {'checked': newValue ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteToDoList(int id) async {
    final db = await instance.database;
    await db.delete(
      'todolists',
      where: 'id = ?',
      whereArgs: [id],
    );
    await db.delete(
      'todos',
      where: 'list_id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteToDo(int id) async {
    final db = await instance.database;
    await db.delete(
      'todos',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
