import 'package:flutter/material.dart';
import 'package:listapp/model/todo_list.dart';
import 'package:listapp/widgets/menu_button.dart';

final _lightColors = [
  Colors.amber.shade300,
  Colors.lightGreen.shade300,
  Colors.lightBlue.shade300,
  Colors.orange.shade300,
  Colors.pinkAccent.shade100,
  Colors.tealAccent.shade100
];

class ListCard extends StatelessWidget {
  const ListCard(
      {Key? key,
      required this.list,
      required this.index,
      required this.onDelete})
      : super(key: key);

  final ToDoList list;
  final int index;
  final void Function(int id) onDelete;

  @override
  Widget build(BuildContext context) {
    /// Pick colors from the accent colors based on index
    final color = _lightColors[index % _lightColors.length];

    return Card(
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Row(children: [
          Expanded(
            child: Text(
              list.name,
              style: TextStyle(
                color: color,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          MenuButton(onDelete: onDelete, id: list.id)
        ]),
      ),
    );
  }
}
