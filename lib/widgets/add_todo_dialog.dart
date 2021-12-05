import 'package:flutter/material.dart';

import 'add_button.dart';

///Represents a Dialog with a text field and a Add-Button.
///The onFinish-Method is triggered when the button is pressed.
class AddToDoDialog extends StatefulWidget {
  const AddToDoDialog({Key? key, required this.onFinish}) : super(key: key);
  final void Function(String) onFinish;

  @override
  _AddToDoDialogState createState() => _AddToDoDialogState();
}

class _AddToDoDialogState extends State<AddToDoDialog> {
  String _val = "";
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Row(
          children: [
            Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    onChanged: (text) =>
                        setState(() {
                      _val = text;
                    }),
                    onSubmitted: (text) {
                      _val = text;
                      },
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )),
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: AddButton(onPressed: () {
                  widget.onFinish(_val);
                  Navigator.of(context).pop();
                })),
          ],
        ));
  }
}
