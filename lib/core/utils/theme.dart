import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: Color(0xFFF5F5F5),
  cardColor: Color(0xFFFFFFFF),
  primaryColor: Color(0xE91E63),
  iconTheme: IconThemeData(color: Color(0xE91E63)),
  textTheme: TextTheme(bodyLarge: TextStyle(color: Color(0xFF333333))),
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: Color(0xFF1A1C3D),
  cardColor: Color(0xFF0D103F),
  primaryColor: Color(0xE91E63),
  iconTheme: IconThemeData(color: Color(0xE91E63)),
  textTheme: TextTheme(bodyLarge: TextStyle(color: Colors.white)),
);
