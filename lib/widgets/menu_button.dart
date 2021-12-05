import 'package:flutter/material.dart';
enum ButtonValues{delete}

class MenuButton extends StatelessWidget {
  const MenuButton({Key? key, required this.onDelete, required this.id}) : super(key: key);

  final void Function(int id) onDelete;
  final int id;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<ButtonValues>(
      onSelected: (value) => _onSelected(value),
      itemBuilder: (context) => [
        const PopupMenuItem<ButtonValues>(
            value: ButtonValues.delete,
            child: Text(
              "Löschen",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),)),
      ],
    );
  }
  void _onSelected(ButtonValues value) {
    switch(value) {
      case ButtonValues.delete: {
        onDelete(id);
        return;
      }
      default: return;
    }
  }
}
