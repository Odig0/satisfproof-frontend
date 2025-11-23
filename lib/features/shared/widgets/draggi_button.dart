import 'package:flutter/material.dart';

class DraggiButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const DraggiButton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white.withAlpha(100),
        foregroundColor: Colors.white,
      ),
      child: Text(text),
    );
  }
}
