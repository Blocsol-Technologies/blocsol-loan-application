class ListItem {
  final String value;
  final String text;

  ListItem({required this.value, required this.text});
}

class InitUtils {
  static List<ListItem> bankAccountTypes = [
    ListItem(text: "Current", value: "current"),
    ListItem(text: "Saving", value: "saving"),
  ];
}
