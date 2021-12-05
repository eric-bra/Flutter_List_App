import 'package:flutter/material.dart';
import 'package:listapp/DataManaging/db_handler.dart';
import 'package:listapp/widgets/add_button.dart';
import 'package:listapp/widgets/add_todo_dialog.dart';
import 'package:listapp/widgets/todolisttile.dart';

class ToDoListing extends StatefulWidget {
  const ToDoListing({Key? key, required this.listId, required this.listName})
      : super(key: key);

  final String listName;
  final int listId;

  @override
  _ToDoListingState createState() => _ToDoListingState();
}

class _ToDoListingState extends State<ToDoListing> {
  final DbHandler _toDoHandler = DbHandler.instance;

  void _onCheck(bool newValue, int id) {
    setState(() {
      _toDoHandler.update(newValue, id);
    });
  }

  void _addTodo(String name) {
    setState(() {
      if (name.isNotEmpty) {
        _toDoHandler.insertTodo(name, widget.listId);
      }
    });
  }

  void _createNewTodo(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return AddToDoDialog(onFinish: _addTodo);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
        widget.listName,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      )),
      body: FutureBuilder<List>(
        future: _toDoHandler.todosByList(widget.listId),
        initialData: List.empty(),
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (_, int index) {
                    final item = snapshot.data![index];
                    return ToDoListTile(todo: item, onCheck: _onCheck);
                  },
                )
              : const Center(
                  child: CircularProgressIndicator(),
                );
        },
      ),
      floatingActionButton: AddButton(onPressed: () {
        _createNewTodo(context);
      }),
    );
  }
}
