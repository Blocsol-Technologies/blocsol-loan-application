class ListItem {
  final String value;
  final String text;

  ListItem({required this.value, required this.text});
}

class SelectUtils {
  static List<ListItem> offerfilters = [
    ListItem(text: "Asc", value: "asc"),
    ListItem(text: "Desc", value: "dsc"),
  ];
}
