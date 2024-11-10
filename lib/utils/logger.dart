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
  try {
    final stringParameters = _convertValuesToString(parameters);

    await FirebaseAnalytics.instance.logEvent(
      name: eventName,
      parameters: stringParameters,
    );
  } catch (e) {
    logger.e("error logging firebase event: $e");
  }
}

Map<String, String> _convertValuesToString(Map<String, Object> parameters) {
  return parameters.map((key, value) {
    String stringValue;

    if (value is List<Object>) {
      stringValue = _convertListToString(value);
    } else if (value is Map<String, Object>) {
      stringValue = _convertValuesToString(value).toString();
    } else {
      stringValue = _valueToString(value);
    }

    return MapEntry(key, stringValue);
  });
}

String _convertListToString(List<Object> list) {
  final stringList = list.map((item) {
    if (item is Map<String, Object>) {
      return _convertValuesToString(item).toString();
    } else {
      return _valueToString(item);
    }
  }).toList();

  return stringList.toString();
}

String _valueToString(Object value) {
  return value.toString(); 
}
