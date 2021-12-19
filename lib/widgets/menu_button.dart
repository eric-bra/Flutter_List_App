import 'package:flutter/material.dart';
import 'package:listapp/constants.dart';

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
          const PopupMenuItem<ButtonValues>(
            value: ButtonValues.delete,
            child: Text(
              'Löschen',
              style: style,
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
