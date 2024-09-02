import 'package:flutter/material.dart';

String fontFamily = "Poppins";

List<List<Color>> bottomNavBarIconsGradientColors = [
  [
    const Color.fromRGBO(0, 43, 92, 1),
    const Color.fromRGBO(0, 157, 170, 1),
  ],
  [
    const Color.fromRGBO(0, 157, 170, 1),
    const Color.fromRGBO(0, 43, 92, 1),
  ]
];

var personLoanThemeVal = ThemeData(
  fontFamily: fontFamily,
  unselectedWidgetColor: const Color.fromRGBO(35, 35, 40, 1),
  colorScheme: const ColorScheme(
    brightness: Brightness.light,
    surface: Color.fromRGBO(255, 253, 250, 1),
    onSurface: Color.fromRGBO(35, 35, 40, 1),
    primary: Color.fromRGBO(0, 81, 33, 1),
    onPrimary: Color.fromRGBO(255, 255, 255, 1),
    secondary: Color.fromRGBO(90, 122, 249, 1),
    onSecondary: Color.fromRGBO(255, 255, 255, 1),
    tertiary: Color.fromRGBO(225, 226, 206, 1),
    onTertiary: Color.fromRGBO(35, 35, 40, 1),
    primaryContainer: Color.fromRGBO(39, 188, 92, 1),
    onPrimaryContainer: Color.fromRGBO(255, 255, 255, 1),
    error: Color.fromRGBO(255, 59, 48, 1),
    onError: Color.fromRGBO(255, 255, 255, 1),
    scrim: Color.fromRGBO(128, 128, 128, 1),
  ),
  bottomSheetTheme: BottomSheetThemeData(
    backgroundColor: Colors.black.withOpacity(0),
  ),
  useMaterial3: true,
);
