import 'package:blocsol_loan_application/utils/logger.dart';

// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

class ErrorInstance {
  String message;
  StackTrace? trace;
  Object exception;
  late String time;

  ErrorInstance({
    this.exception = '',
    required this.message,
    this.trace,
  }) {
    DateTime now = DateTime.now();
    time = DateFormat('HH:mm:ss').format(now);
  }

  Future<void> reportError() async {
    logger.e("Error log", error: exception, stackTrace: trace);
    // await Sentry.captureException(
    //   exception,
    //   stackTrace: trace,
    // );
  }
}
