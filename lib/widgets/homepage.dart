import 'package:flutter/material.dart';
import 'package:listapp/DataManaging/db_handler.dart';
import 'package:listapp/DataManaging/esense_handler.dart';
import 'package:listapp/model/todo_list.dart';
import 'package:listapp/widgets/add_button.dart';
import 'package:listapp/widgets/connection_indicator.dart';
import 'package:listapp/widgets/speech_controllers/hp_movement_speech_controller.dart';
import 'package:listapp/widgets/speech_controllers/hp_touch_speech_controller.dart';
import 'package:listapp/widgets/todo_listing.dart';

import '../custom_theme.dart';
import 'add_todo_dialog.dart';
import 'list_card.dart';

/// Represents the scaffold you can see when opening the app. It represents a List of to do lists.
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DbHandler _db = DbHandler.instance;
  final ESenseHandler _eSense = ESenseHandler.instance;
  late List<ToDoList> lists;

  @override
  void initState() {
    super.initState();
    _refreshLists();
  }

  _refreshLists() async {
    lists = await _db.todoLists();
  }

  void _createNewTodoList(BuildContext context) {
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(15.0))),
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return AddToDoDialog(onFinish: _addTodoList);
        });
  }

  void _addTodoList(String name) {
    setState(() {
      _db.insertTodoList(name, DateTime.now().millisecondsSinceEpoch);
    });
    _refreshLists();
  }

  void _deleteTodoList(int id) {
    setState(() {
      _db.deleteToDoList(id);
    });
    _refreshLists();
  }

  void _openList(int id) async {
    var element = lists.firstWhere((element) => element.getId() == id);
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ToDoListing(
          listId: element.id,
          listName: element.name,
        ),
      ),
    );
  }

  void _readListElements(BuildContext context) async {
    if (lists.isEmpty) return;
    bool movement = await _eSense.liveConnected;
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return movement
              ? HpMovementSpeechController(
                  onAction: _openList,
                  list: lists,
                )
              : HpTouchSpeechController(onAction: _openList, list: lists);
        });
  }

  @override
  Widget build(BuildContext context) {
      return buildScaffold();
  }

  Widget buildScaffold() {
    return Scaffold(
      appBar: AppBar(
        actions: [
          const ConnectionIndicator(),
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
          "Listen",
          style: Theme.of(context).textTheme.headline6?.merge(TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: (Theme.of(context).textTheme.headline6 != null)
                  ? Theme.of(context).textTheme.headline6!.fontSize! + 2
                  : null)),
        ),
      ),
      body: SafeArea(
            child: FutureBuilder<List<ToDoList>>(
              future: _db.todoLists(),
              initialData: List.empty(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.data!.isEmpty) {
                  return Center(
                      child: Text(
                        'Keine Listen',
                        style: Theme.of(context).textTheme.subtitle1?.merge(TextStyle(
                            fontSize: (Theme.of(context).textTheme.subtitle1 != null)
                                ? Theme.of(context).textTheme.subtitle1!.fontSize! + 2
                                : null)),
                      ));
                }
                List<ToDoList> toDoLists = snapshot.data!;
                return buildList(toDoLists, context);
              },
            )),
      floatingActionButton: AddButton(
        onPressed: () {
          _createNewTodoList(context);
        },
      ),
    );
  }

  ListView buildList(List<ToDoList> toDoLists, BuildContext context) =>
      ListView.builder(
          itemCount: toDoLists.length,
          itemBuilder: (_, int index) {
            final list = toDoLists[index];
            return GestureDetector(
              onTap: () async {
                await Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ToDoListing(
                    listId: list.id,
                    listName: list.name,
                  ),
                ));
              },
              child: ListCard(
                list: list,
                index: index,
                onDelete: _deleteTodoList,
              ),
            );
          });
}
