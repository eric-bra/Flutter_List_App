import 'package:flutter/material.dart';
import 'package:listapp/model/todo_list.dart';
import 'package:listapp/widgets/menu_button.dart';

final _darkColors = [
  Colors.amber.shade300,
  Colors.lightGreen.shade300,
  Colors.lightBlue.shade300,
  Colors.orange.shade300,
  Colors.pinkAccent.shade100,
  Colors.tealAccent.shade100
];

final _lightColors = [
  Colors.amber.shade200,
  Colors.lightGreen.shade200,
  Colors.lightBlue.shade200,
  Colors.orange.shade200,
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

    return Card(
      color: MediaQuery.of(context).platformBrightness != Brightness.dark
          ? _lightColors[index % _lightColors.length]
          : null,
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Row(children: [
          Expanded(
            child: Text(
              list.name,
              style: Theme.of(context).textTheme.button?.merge(TextStyle(
                    fontSize: (Theme.of(context).textTheme.button != null)
                        ? Theme.of(context).textTheme.button!.fontSize! + 2
                        : null,
                    color: MediaQuery.of(context).platformBrightness ==
                            Brightness.dark
                        ? _darkColors[index % _lightColors.length]
                        : null,
                  )),
            ),
          ),
          MenuButton(onDelete: onDelete, id: list.id),
        ]),
      ),
    );
  }
}
