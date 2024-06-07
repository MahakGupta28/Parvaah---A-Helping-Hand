import 'package:flutter/material.dart';
import 'package:parvaah_helping_hand/src/utils/theme/widget_themes/text_theme.dart';

class TAppTheme {
  TAppTheme._();

  static ThemeData lightTheme = ThemeData(
    primarySwatch: const MaterialColor(
      0xFF640085, // Replace with your desired purple color code
      <int, Color>{
        50: Color(0xFFF5E6F4),
        100: Color(0xFFE1B0E4),
        200: Color(0xFFCE80D4),
        300: Color(0xFFBA49C3),
        400: Color(0xFFA925B4),
        500: Color(0xFF9400A5),
        600: Color(0xFF86009A),
        700: Color(0xFF75008F),
        800: Color(0xFF640085),
        900: Color(0xFF4C0078),
      },
    ),
    brightness: Brightness.light,
    textTheme: TTextTheme.lightTextTheme,
    appBarTheme: const AppBarTheme(),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(),
    elevatedButtonTheme:
        ElevatedButtonThemeData(style: ElevatedButton.styleFrom()),
  );

  static ThemeData darkTheme = ThemeData(
    primarySwatch: const MaterialColor(
      0xF00BFFFF, // Replace with your desired aqua blue color code
      <int, Color>{
        50: Color(0xFFE0FFFF),
        100: Color(0xFFB0E0E6),
        200: Color(0xFF87CEEB),
        300: Color(0xFF5F9EA0),
        400: Color(0xFF4682B4),
        500: Color(0xFF00CED1),
        600: Color(0xFF00BFFF),
        700: Color(0xFF1E90FF),
        800: Color(0xFF4169E1),
        900: Color(0xFF0000FF),
        1000: Color(0xFF87CEFA), // LightSkyBlue
        1100: Color(0xFF00FA9A), // MediumSpringGreen
        1200: Color(0xFF00FF7F), // SpringGreen
        1300: Color(0xFF20B2AA), // LightSeaGreen
      },
    ),
    brightness: Brightness.dark,
    textTheme: TTextTheme.darkTextTheme,
    appBarTheme: const AppBarTheme(),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(),
    elevatedButtonTheme:
        ElevatedButtonThemeData(style: ElevatedButton.styleFrom()),
  );
}
