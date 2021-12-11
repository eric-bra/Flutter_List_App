import 'package:flutter/material.dart';
import 'package:listapp/DataManaging/db_handler.dart';
import 'package:listapp/constants.dart';
import 'package:listapp/model/todo.dart';
import 'package:listapp/widgets/add_button.dart';
import 'package:listapp/widgets/add_todo_dialog.dart';
import 'package:listapp/widgets/speech_controller.dart';
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
  late List<ToDo> list;
  bool _isLoading = false;
  final DbHandler _db = DbHandler.instance;

  @override
  void initState() {
    super.initState();
    _refreshList();
  }

  _refreshList() async {
    setState(() {
      _isLoading = true;
    });
    list = await _db.todosByList(widget.listId);
    setState(() {
      _isLoading = false;
    });
  }

  void _onCheck(bool newValue, int id) {
    _db.update(newValue, id);
    _refreshList();
  }

  void _addTodo(String name) {
    if (name.isNotEmpty) {
      _db.insertTodo(name, widget.listId);
    }
    _refreshList();
  }

  void _createNewTodo(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return AddToDoDialog(onFinish: _addTodo);
        });
  }

  void _openList(BuildContext context, int counter) async {
    if (counter < list.length) {
      _onCheck(!list[counter].checked, list[counter].id);
    }
  }

  void _readListElements(BuildContext context) {
    if (list.isEmpty) return;
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return SpeechController(
            onAction: _openList,
            getListLength: () => list.length,
            getString: (int counter) => list[counter].content,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          actions: [
            MaterialButton(
              child: Icon(
                Icons.play_arrow_rounded,
                color: ThemeData.dark().indicatorColor,
              ),
              onPressed: () => _readListElements(context),
            ),
          ],
          title: Text(
            widget.listName,
            style: style,
          )),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: list.length,
              itemBuilder: (_, int index) {
                final item = list[index];
                return ToDoListTile(todo: item, onCheck: _onCheck);
              },
            ),
      floatingActionButton: AddButton(
        onPressed: () {
          _createNewTodo(context);
        },
      ),
    );
  }
}
