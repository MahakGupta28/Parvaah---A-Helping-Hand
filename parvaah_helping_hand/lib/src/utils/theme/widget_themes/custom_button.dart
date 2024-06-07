import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    Key? key,
    required this.onTap,
    required this.text,
    required this.isDarkmode,
  }) : super(key: key);

  final String text;
  final VoidCallback onTap;
  final bool isDarkmode;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 40),
        backgroundColor: isDarkmode
            ? const Color.fromARGB(255, 223, 173, 241)
            : const Color.fromARGB(255, 58, 9, 81),
      ),
      onPressed: onTap,
      child: Text(
        text,
        style: TextStyle(
          color: isDarkmode ? Colors.black : Colors.white,
        ),
      ),
    );
  }
}
