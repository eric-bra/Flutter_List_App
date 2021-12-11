import 'package:flutter/material.dart';
import 'package:listapp/DataManaging/db_handler.dart';
import 'package:listapp/constants.dart';
import 'package:listapp/model/todo_list.dart';
import 'package:listapp/widgets/add_button.dart';
import 'package:listapp/widgets/speech_controller.dart';
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
  bool _isLoading = false;
  final DbHandler _db = DbHandler.instance;
  late List<ToDoList> lists;

  @override
  void initState() {
    super.initState();
    _refreshLists();
  }

  _refreshLists() async {
    setState(() {
      _isLoading = true;
    });
    lists = await _db.todoLists();
    setState(() {
      _isLoading = false;
    });
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

  void _openList(BuildContext context, int counter) async {
    if (counter < lists.length) {
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ToDoListing(
            listId: lists[counter].id,
            listName: lists[counter].name,
          ),
        ),
      );
    }
  }

  void _readListElements(BuildContext context) {
    if (lists.isEmpty) return;
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return SpeechController(
            onAction: _openList,
            getListLength: () => lists.length,
            getString: (int counter) => lists[counter].name,
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
        title: const Text(
          "Listen",
          style: style,
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : lists.isEmpty
              ? const Center(
                  child: Text(
                  'Keine Listen',
                  style: style,
                ))
              : buildLists(context),
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
