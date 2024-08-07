import 'package:blocsol_loan_application/invoice_loan/constants/theme.dart';
import 'package:blocsol_loan_application/personal_loan/contants/theme.dart';
import 'package:flutter/material.dart';

class AppThemeData {
  static final ThemeData defaultTheme = defaultThemeVal; 
  static final ThemeData invoiceLoanTheme = invoiceLoanThemeVal;
  static final ThemeData personalLoanTheme = personLoanThemeVal;
}

String fontFamily = "Poppins";

var defaultThemeVal = ThemeData(
  fontFamily: fontFamily,
  unselectedWidgetColor: const Color.fromRGBO(35, 35, 40, 1),
  colorScheme: const ColorScheme(
    brightness: Brightness.light,
    primary: Color.fromRGBO(7, 92, 128, 1),
    onPrimary: Color.fromRGBO(255, 255, 255, 1),
    secondary: Color.fromRGBO(3, 145, 155, 1),
    onSecondary: Color.fromRGBO(35, 35, 40, 1),
    tertiary: Color.fromRGBO(233, 233, 250, 1),
    onTertiary: Color.fromRGBO(35, 35, 40, 1),
    primaryContainer: Color.fromRGBO(39, 188, 92, 1),
    onPrimaryContainer: Color.fromRGBO(255, 255, 255, 1),
    surface: Color.fromRGBO(233, 255, 252, 1),
    onSurface: Color.fromRGBO(35, 35, 40, 1),
    error: Color.fromRGBO(255, 59, 48, 1),
    onError: Color.fromRGBO(255, 255, 255, 1),
    scrim: Color.fromRGBO(128, 128, 128, 1),
  ),
  bottomSheetTheme: BottomSheetThemeData(
    backgroundColor: Colors.black.withOpacity(0),
  ),
  useMaterial3: true,
);
