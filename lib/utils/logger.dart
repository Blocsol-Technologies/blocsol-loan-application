import 'package:logger/logger.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

var logger = Logger(
  filter: null,
  printer: PrettyPrinter(
    methodCount: 2,
    errorMethodCount: 8,
    lineLength: 120,
    colors: true,
    printEmojis: true,
    dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
  ),
  output: null,
);

void logFirebaseEvent(String eventName, Map<String, Object> parameters) async {
  await FirebaseAnalytics.instance.logEvent(
    name: "invoice_loan_customer_signup",
    parameters: parameters,
  );
}
