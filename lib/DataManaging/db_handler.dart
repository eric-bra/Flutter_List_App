import 'dart:async';

import 'package:listapp/model/todo.dart';
import 'package:listapp/model/todo_list.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

/// Wraps plugins that handles persistence.
class DbHandler {
  ///Instance of the Database handler which is to be always used.
  static final DbHandler instance = DbHandler._init();

  /// Actual Database instance.
  static Database? _db;

  /// initiates the database handler.
  DbHandler._init() {
    database;
  }

  /// Returns the database. Using this makes sure that the database has been initialized.
  Future<Database> get database async {
    if (_db != null) return _db!;

    _db = await _initDB();
    return _db!;
  }

  /// Initializes the database and creates tables if necessary.
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

  ///Returns all todos in the database.
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

  /// Returns all Todolists in the Database.
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

  /// Returns all todos that belong to a certain list.
  Future<List<ToDo>> todosByList(int listId) async {
    // Get a reference to the database.
    final db = await instance.database;

    final List<Map<String, dynamic>> maps =
        await db.query('todos', where: 'list_id = ?', whereArgs: [listId]);

    return List.generate(maps.length, (i) {
      return ToDo(
        id: maps[i]['id'],
        content: maps[i]['content'],
        checked: (maps[i]['checked'] == 1) ? true : false,
        listId: maps[i]['list_id'],
      );
    });
  }

  /// Inserts a new toDoElement into the data base.
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

  /// Inserts a new ToDoList into the Database.
  Future<void> insertTodoList(String name, int listId) async {
    ToDoList list = ToDoList(
      name: name,
      id: DateTime.now().millisecondsSinceEpoch,
    );
    final db = await instance.database;
    await db.insert(
      'todolists',
      list.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Updates the checked parameter of the ToDoElement with the given id.
  Future<void> update(bool newValue, int id) async {
    final db = await instance.database;
    await db.update(
      'todos',
      {'checked': newValue ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Deletes the Todolist with the given ID.
  /// Also makes sure that all ToDoElements that belongs to the List are deleted as well.
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

  /// Deletes the given ToDoElement from the Database.
  Future<void> deleteToDo(int id) async {
    final db = await instance.database;
    await db.delete(
      'todos',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
