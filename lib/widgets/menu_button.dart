import 'package:flutter/material.dart';

enum ButtonValues { delete }

class MenuButton extends StatelessWidget {
  const MenuButton({Key? key, required this.onDelete, required this.id})
      : super(key: key);

  final void Function(int id) onDelete;
  final int id;

  @override
  Widget build(BuildContext context) {
    return RotatedBox(
      quarterTurns: 1,
      child: PopupMenuButton<ButtonValues>(
        icon: Icon(Icons.adaptive.more),
        onSelected: (value) => _onSelected(value),
        itemBuilder: (context) => [
          PopupMenuItem<ButtonValues>(
            value: ButtonValues.delete,
            child: Text(
              'Löschen',
              style: Theme.of(context).textTheme.button?.merge(TextStyle(
                  fontSize: (Theme.of(context).textTheme.button != null)
                      ? Theme.of(context).textTheme.button!.fontSize! + 2
                      : null)),
            ),
          ),
        ],
      ),
    );
  }

  void _onSelected(ButtonValues value) {
    switch (value) {
      case ButtonValues.delete:
        {
          onDelete(id);
          return;
        }
      default:
        return;
    }
  }
}
