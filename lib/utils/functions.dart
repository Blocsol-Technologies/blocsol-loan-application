import 'package:intl/intl.dart';

String getStateNameFromStateCode(String stateCode) {
  switch (stateCode) {
    case "37":
      return "Andhra Pradesh";
    case "12":
      return "Arunachal Pradesh";
    case "18":
      return "Assam";
    case "10":
      return "Bihar";
    case "22":
      return "Chhattisgarh";
    case "07":
      return "Delhi";
    case "30":
      return "Goa";
    case "24":
      return "Gujarat";
    case "06":
      return "Haryana";
    case "02":
      return "Himachal Pradesh";
    case "01":
      return "Jammu and Kashmir";
    case "20":
      return "Jharkhand";
    case "29":
      return "Karnataka";
    case "32":
      return "Kerala";
    case "31":
      return "Lakshadweep Islands";
    case "23":
      return "Madhya Pradesh";
    case "27":
      return "Maharashtra";
    case "14":
      return "Manipur";
    case "17":
      return "Meghalaya";
    case "15":
      return "Mizoram";
    case "21":
      return "Odisha";
    case "34":
      return "Puducherry";
    case "03":
      return "Punjab";
    case "08":
      return "Rajasthan";
    case "11":
      return "Sikkim";
    case "33":
      return "Tamil Nadu";
    case "36":
      return "Telangana";
    case "16":
      return "Tripura";
    case "09":
      return "Uttar Pradesh";
    case "05":
      return "Uttarakhand";
    case "19":
      return "West Bengal";
    case "35":
      return "Andaman and Nicobar Islands";
    case "04":
      return "Chandigarh";
    case "26":
      return "Dadra & Nagar Haveli and Daman & Diu";
    case "38":
      return "Ladakh";
    default:
      return "Other territory";
  }
}

String convertUnixToHumanReadable(int unixTime) {
  DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(unixTime * 1000);

  // Define the desired format
  DateFormat dateFormat = DateFormat('dd MMM yy HH:mm');

  // Format the DateTime
  String formattedDate = dateFormat.format(dateTime);

  return formattedDate;
}

String getFormattedTime(String time) {
  try {
    DateTime dateTime = DateTime.parse(time);

    String formattedEndDate = DateFormat('d MMM, yyyy hh:mm').format(dateTime);
    return formattedEndDate;
  } catch (e) {
    return 'NA';
  }
}
