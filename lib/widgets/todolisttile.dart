import 'package:flutter/material.dart';
import 'package:listapp/model/todo.dart';

class ToDoListTile extends StatelessWidget {
  const ToDoListTile({Key? key, required this.todo, required this.onCheck})
      : super(key: key);
  final ToDo todo;
  final Function(bool b, int n) onCheck;

  @override
  Widget build(BuildContext context) {
    return Card(
        color: todo.checked ? ThemeData.dark().disabledColor : ThemeData.dark().cardColor,
        child: CheckboxListTile(
            title: Text(
              todo.content,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            value: todo.checked,
            onChanged: (b) {
              if (b != null) {
                onCheck(b, todo.id);
              }
            }));
  }
}
