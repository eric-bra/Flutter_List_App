import 'package:flutter/material.dart';

/// Widget which represents a FloatingActionButton with an add-Icon.
class AddButton extends StatelessWidget {
  const AddButton({Key? key, required this.onPressed}) : super(key: key);

  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
        child: const Icon(Icons.add), onPressed: onPressed);
  }
}
