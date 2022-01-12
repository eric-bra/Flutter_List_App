import 'package:flutter/material.dart';
import 'package:listapp/DataManaging/esense_handler.dart';

import '../custom_theme.dart';
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
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(15.0))),
        isScrollControlled: true,
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
              side: BorderSide(color: CustomTheme.borderColor(context))),
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
        child: SafeArea(
            child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: Text(
                  "Aktueller Kopfhörer: ${widget.name}",
                  style: Theme.of(context).textTheme.bodyText1?.merge(TextStyle(
                      fontSize: (Theme.of(context).textTheme.bodyText1 != null)
                          ? Theme.of(context).textTheme.bodyText1!.fontSize! + 2
                          : null)),
                )),
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
                      )),
                ),
                Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    child: AddButton(onPressed: () {
                      widget.onFinish(_val);
                      Navigator.of(context).pop();
                    })),
              ],
            )
          ],
        )));
  }
}
