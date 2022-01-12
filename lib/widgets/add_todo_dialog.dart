import 'package:flutter/material.dart';

import '../custom_theme.dart';
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
        child: SafeArea(
            child: Row(
          children: [
            Expanded(
                child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: CustomTheme.current(context) == CustomTheme.light
                  ? TextField(
                      autofocus: true,
                      onChanged: (text) => setState(() {
                        _val = text;
                      }),
                      onSubmitted: (text) {
                        _val = text;
                      },
                      cursorColor: const Color(0xff666666),
                      decoration: const InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xff666666)),
                        ),
                      ),
                      style: Theme.of(context).textTheme.bodyText1,
                    )
                  : TextField(
                      autofocus: true,
                      onChanged: (text) => setState(() {
                        _val = text;
                      }),
                      onSubmitted: (text) {
                        _val = text;
                      },
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
            )),
            Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: AddButton(onPressed: () {
                  widget.onFinish(_val);
                  Navigator.of(context).pop();
                })),
          ],
        )));
  }
}
