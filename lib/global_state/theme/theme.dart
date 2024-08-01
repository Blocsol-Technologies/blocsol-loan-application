import 'package:blocsol_loan_application/global_state/theme/theme_state.dart';
import 'package:blocsol_loan_application/utils/secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'theme.g.dart';

enum ThemeState {
  defaultTheme,
  invoiceLoanTheme,
  personalLoanTheme,
}

extension ThemeStateExtension on ThemeState {
  String get value {
    switch (this) {
      case ThemeState.invoiceLoanTheme:
        return 'invoice-loan-theme';
      case ThemeState.personalLoanTheme:
        return 'personal-loan-theme';
      default:
        return 'default-theme';
    }
  }
}

@riverpod
class AppTheme extends _$AppTheme {
  @override
  Future<ThemeData> build() async {
    String? theme = await SecureStorage.read('theme');
    if (theme == null) {
      SecureStorage.write('theme', 'default-theme');
      return AppThemeData.defaultTheme;
    } else {
      if (theme == 'invoice-loan-theme') {
        return AppThemeData.invoiceLoanTheme;
      } else {
        return AppThemeData.personalLoanTheme;
      }
    }
  }

  Future<void> toggleTheme(ThemeState theme) async {
    String themeVal = theme.value;
    await SecureStorage.write('theme', themeVal);
  }
}
