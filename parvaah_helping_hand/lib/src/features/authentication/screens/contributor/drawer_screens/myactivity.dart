import 'package:flutter/material.dart';
import 'package:parvaah_helping_hand/src/constants/colors.dart';

class MyActivityScreen extends StatefulWidget {
  final String userId;

  const MyActivityScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _MyActivityScreenState createState() => _MyActivityScreenState();
}

class _MyActivityScreenState extends State<MyActivityScreen> {
  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    var brightness = mediaQuery.platformBrightness;
    final isDarkMode = brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDarkMode ? tAccentColor : tDashboardBg,
      appBar: AppBar(
        title: Text(
          'My Activity',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : tPrimaryColor,
          ),
        ),
        backgroundColor: isDarkMode ? tPrimaryColor : tBgColor,
      ),
    );
  }
}
