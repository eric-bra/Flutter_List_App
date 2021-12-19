import 'package:flutter/material.dart';
import 'package:listapp/DataManaging/db_handler.dart';
import 'package:listapp/DataManaging/esense_handler.dart';
import 'package:listapp/constants.dart';
import 'package:listapp/model/todo_list.dart';
import 'package:listapp/widgets/add_button.dart';
import 'package:listapp/widgets/speech_controllers/hp_movement_speech_controller.dart';
import 'package:listapp/widgets/speech_controllers/touch_speech_controller.dart';
import 'package:listapp/widgets/todo_listing.dart';
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
        context: context,
        builder: (context) {
          return AddToDoDialog(onFinish: _addTodoList);
        });
  }

  void _addTodoList(String name) {
    _db.insertTodoList(name, DateTime.now().millisecondsSinceEpoch);
    _refreshLists();
  }

  void _deleteTodoList(int id) {
    _db.deleteToDoList(id);
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
    print("Starting to connect");
    bool movement = await _eSense.liveConnected;
    if (!movement) {
      movement = await _eSense.connectToESense();
    }
    print("Connection is $movement");
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return movement
              ? HpMovementSpeechController(
                  onAction: _openList,
                  list: lists,
                )
              : TouchSpeechController(onAction: _openList, list: lists);
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
        title: const Text(
          "Listen",
          style: style,
        ),
      ),
      body: FutureBuilder<List>(
        future: _db.todoLists(),
        initialData: null,
        builder: (context, snapshot) {
          return !snapshot.hasData
              ? const Center(child: CircularProgressIndicator())
              : snapshot.data!.isEmpty
                  ? const Center(
                      child: Text(
                      'Keine Listen',
                      style: style,
                    ))
                  : buildLists(context);
        },
      ),
      floatingActionButton: AddButton(
        onPressed: () {
          _createNewTodoList(context);
        },
      ),
    );
  }

  Widget buildLists(context) => ListView.builder(
      itemCount: lists.length,
      itemBuilder: (context, index) {
        final list = lists[index];
        return GestureDetector(
          onTap: () async {
            await Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ToDoListing(
                listId: list.id,
                listName: list.name,
              ),
            ));

            _refreshLists();
          },
          child: ListCard(
            list: list,
            index: index,
            onDelete: _deleteTodoList,
          ),
        );
      });
}
