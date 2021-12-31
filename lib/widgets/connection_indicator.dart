import 'package:flutter/material.dart';
import 'package:listapp/DataManaging/esense_handler.dart';

import 'add_button.dart';

class ConnectionIndicator extends StatefulWidget {
  const ConnectionIndicator({Key? key}) : super(key: key);

  @override
  _ConnectionIndicatorState createState() => _ConnectionIndicatorState();
}

class _ConnectionIndicatorState extends State<ConnectionIndicator> {
  final _eSense = ESenseHandler.instance;

  void _changeName() async {
    var name = await _eSense.eSenseName;
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return ChangeNameDialog(
            onFinish: (nName) async {
              if (nName.isNotEmpty) {
                await _eSense.setESenseName(nName);
                _eSense.connectToESense();
              }
            },
            name: name,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: OutlinedButton(
          style: OutlinedButton.styleFrom(
              side: BorderSide(color: ThemeData.dark().cardColor)),
          onPressed: _changeName,
          child: ValueListenableBuilder<bool>(
              valueListenable: _eSense.connectionNotifier,
              builder: (context, value, widget) {
                return Icon(Icons.headphones,
                    color: value ? Colors.green : Colors.red);
              })),
    );
  }
}

class ChangeNameDialog extends StatefulWidget {
  const ChangeNameDialog({Key? key, required this.onFinish, required this.name})
      : super(key: key);
  final void Function(String) onFinish;
  final String name;

  @override
  _ChangeNameDialogState createState() => _ChangeNameDialogState();
}

class _ChangeNameDialogState extends State<ChangeNameDialog> {
  String _val = "";
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: Text("Aktueller Kopfhörer: ${widget.name}")),
            const Divider(
              height: 3,
              thickness: 2,
              indent: 7,
              endIndent: 7,
            ),
            Row(
              children: [
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    onChanged: (text) => setState(() {
                      _val = text;
                    }),
                    onSubmitted: (text) {
                      _val = text;
                    },
                    style: const TextStyle(fontSize: 20),
                  ),
                )),
                Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: AddButton(onPressed: () {
                      widget.onFinish(_val);
                      Navigator.of(context).pop();
                    })),
              ],
            )
          ],
        ));
  }
}
