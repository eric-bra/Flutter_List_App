import 'dart:async';

import 'package:flutter/material.dart';
import 'package:listapp/DataManaging/db_handler.dart';
import 'package:listapp/DataManaging/esense_handler.dart';
import 'package:listapp/model/todo.dart';
import 'package:listapp/widgets/add_button.dart';
import 'package:listapp/widgets/add_todo_dialog.dart';
import 'package:listapp/widgets/speech_controllers/listings_touch_speech_controller.dart';
import 'package:listapp/widgets/todolisttile.dart';

import '../custom_theme.dart';
import 'connection_indicator.dart';
import 'speech_controllers/listings_movement_speech_controller.dart';

class ToDoListing extends StatefulWidget {
  const ToDoListing(
      {Key? key,
      required this.listId,
      required this.listName,
      required this.startInSpeechMode})
      : super(key: key);

  final String listName;
  final int listId;
  final bool startInSpeechMode;

  @override
  _ToDoListingState createState() => _ToDoListingState();
}

class _ToDoListingState extends State<ToDoListing> {
  late List<ToDo> _list;
  final DbHandler _db = DbHandler.instance;
  final _eSense = ESenseHandler.instance;

  bool showChecked = false;

  get list {
    return showChecked
        ? _list
        : _list.where((element) => !element.checked).toList();
  }

  @override
  void initState() {
    super.initState();
    _refreshList();
    if(widget.startInSpeechMode)_openBottomSheet();
  }

  _refreshList() async {
    _list = await _db.todosByList(widget.listId);
  }

  void _onCheck(bool newValue, int id) {
    setState(() {
      _db.update(newValue, id);
    });
    _refreshList();
  }

  void _addTodo(String name) {
    setState(() {
      if (name.isNotEmpty) {
        _db.insertTodo(name, widget.listId);
      }
    });
    _refreshList();
  }

  void _createNewTodo() {
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(15.0))),
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return AddToDoDialog(onFinish: _addTodo);
        });
  }

  void _action(int id) {
    var e = _list.firstWhere((element) => element.id == id);
    _onCheck(!e.checked, e.id);
  }

  void _readListElements(BuildContext context) async {
    if (list.isEmpty) return;
    bool movement = await _eSense.liveConnected;
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(15.0))),
        context: context,
        builder: (context) {
          return movement
              ? ListingsMovementSpeechController(
                  onAction: _action,
                  list: list,
                )
              : ListingsTouchSpeechController(onAction: _action, list: list);
        });
  }

  void _openBottomSheet() async{
    await Future.delayed(const Duration(milliseconds: 300));
    _readListElements(context);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          actions: [
            const ConnectionIndicator(),
            Switch(
                value: showChecked,
                onChanged: (changed) {
                  setState(() {
                    showChecked = changed;
                  });
                }),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                    side: BorderSide(color: CustomTheme.borderColor(context))),
                child: Icon(Icons.play_arrow_rounded,
                    color: CustomTheme.current(context).indicatorColor),
                onPressed: () => _readListElements(context),
              ),
            ),
          ],
          title: Text(
            widget.listName,
            style: Theme.of(context).textTheme.headline6?.merge(TextStyle(
                fontSize: (Theme.of(context).textTheme.headline6 != null)
                    ? Theme.of(context).textTheme.headline6!.fontSize! + 2
                    : null)),
          )),
      body: buildList(),
      floatingActionButton: AddButton(
        onPressed: () {
          _createNewTodo();
        },
      ),
    );
  }

  FutureBuilder<List<ToDo>> buildList() {
    return FutureBuilder<List<ToDo>>(
      future: _db.todosByList(widget.listId),
      initialData: List.empty(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        List<ToDo> list = showChecked
            ? snapshot.data!
            : snapshot.data!.where((element) => !element.checked).toList();
        return ListView.builder(
          itemCount: list.length,
          itemBuilder: (_, int index) {
            final item = list[index];
            _refreshList();
            return ToDoListTile(
                todo: item,
                onCheck: _onCheck,
                onLongPress: (val) {
                  setState(() {
                    _db.deleteToDo;
                  });
                });
          },
        );
      },
    );
  }
}
