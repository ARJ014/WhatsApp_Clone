import 'package:flutter/material.dart';

import '../../resources/colors.dart';

class Button extends StatelessWidget {
  final VoidCallback onpressed;
  final String text;
  const Button({super.key, required this.onpressed, required this.text});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onpressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: tabColor,
        minimumSize: const Size(double.infinity, 50),
      ),
      child: Text(text, style: const TextStyle(color: Colors.black)),
    );
  }
}
