class ListItem {
  final String value;
  final String text;

  ListItem({required this.value, required this.text});
}

class SearchUtils {
  static List<ListItem> employmentType = [
    ListItem(text: "Salaried", value: "salaried"),
    ListItem(text: "Self Employed", value: "selfEmployed"),
  ];

  static List<ListItem> endUse = [
    ListItem(
        text: "Purchase of Consumer Durables",
        value: "consumerDurablePurchase"),
    ListItem(text: "Education", value: "education"),
    ListItem(text: "Health", value: "health"),
    ListItem(text: "Travel", value: "travel"),
    ListItem(text: "Others", value: "other"),
  ];
}
