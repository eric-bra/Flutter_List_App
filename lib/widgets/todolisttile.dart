import 'package:flutter/material.dart';
import 'package:listapp/custom_theme.dart';
import 'package:listapp/model/todo.dart';

class ToDoListTile extends StatelessWidget {
  const ToDoListTile(
      {Key? key,
      required this.todo,
      required this.onCheck,
      required this.onLongPress})
      : super(key: key);
  final ToDo todo;
  final Function(bool b, int n) onCheck;
  final Function(int id) onLongPress;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
        key: Key(todo.id.toString()),
        onDismissed: (dismiss) {
          onLongPress(todo.id);
        },
        child: Card(
            color: todo.checked
                ? CustomTheme.current(context).disabledColor
                : CustomTheme.current(context).cardColor,
            child: CheckboxListTile(
                title: Text(
                  todo.content,
                  style: Theme.of(context).textTheme.bodyText1?.merge(TextStyle(
                      fontSize: (Theme.of(context).textTheme.bodyText1 != null)
                          ? Theme.of(context).textTheme.bodyText1!.fontSize! + 2
                          : null)),
                ),
                value: todo.checked,
                onChanged: (b) {
                  if (b != null) {
                    onCheck(b, todo.id);
                  }
                })));
  }
}
