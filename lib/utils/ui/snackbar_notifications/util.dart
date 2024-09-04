import 'package:blocsol_loan_application/utils/ui/snackbar_notifications/error.dart';
import 'package:blocsol_loan_application/utils/ui/snackbar_notifications/info.dart';
import 'package:blocsol_loan_application/utils/ui/snackbar_notifications/success.dart';
import 'package:blocsol_loan_application/utils/ui/snackbar_notifications/warning.dart';
import 'package:flutter/material.dart';

enum SnackbarNotificationType {
  error,
  warning,
  info,
  success,
}

Widget getSnackbarNotificationWidget(
    {required String message, required SnackbarNotificationType notifType}) {
  switch (notifType) {
    case SnackbarNotificationType.error:
      {
        return ErrorNotification(message: message);
      }
    case SnackbarNotificationType.warning:
      {
        return WarningNotification(message: message);
      }
    case SnackbarNotificationType.info:
      {
        return InfoNotification(message: message);
      }
    case SnackbarNotificationType.success:
      {
        return SuccessNotification(message: message);
      }
  }
}
