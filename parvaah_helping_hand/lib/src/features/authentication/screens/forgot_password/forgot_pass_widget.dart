import 'package:flutter/material.dart';

class ForgotPassBtn extends StatelessWidget {
  const ForgotPassBtn({
    required this.btnIcon,
    required this.title,
    required this.subTitle,
    super.key,
    required this.isDarkMode,
    required this.onTap,
  });
  final IconData btnIcon;
  final String title, subTitle;
  final bool isDarkMode;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(25.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: isDarkMode
                ? const Color.fromARGB(255, 170, 170, 170)
                : const Color.fromARGB(255, 177, 136, 254)),
        child: Row(
          children: [
            Icon(btnIcon, size: 40.0),
            const SizedBox(width: 11.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 23.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold)),
                Text(subTitle,
                    style: const TextStyle(
                        fontSize: 15.0,
                        color: Color.fromARGB(255, 56, 56, 56),
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
