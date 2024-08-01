class Category {
  final String name;
  final String value;
  final List<Subcategory> subCategories;
  Category(
      {required this.name, required this.value, required this.subCategories});
}

class Subcategory {
  final String name;
  final String value;
  final String code;
  Subcategory({required this.name, required this.value, required this.code});
}

List<Category> categories = [
  Category(
      name: 'Issue with Loan Process',
      value: 'FULFILLMENT',
      subCategories: [
        Subcategory(
            name: "Delay in disbursement/not disbursed",
            value: "FLM01",
            code: "1"),
        Subcategory(
            name: "Incorrect amount disbursed", value: "FLM02", code: "2"),
        Subcategory(
            name: "Not able to complete the KYC", value: "FLM202", code: "3"),
        Subcategory(
            name: "Not able to set up E-mandate", value: "FLM203", code: "4"),
        Subcategory(
            name: "OTP not received during the e-sign of agreement",
            value: "FLM204",
            code: "5"),
        Subcategory(
            name: "Not able to view the agreement", value: "FLM205", code: "6"),
        Subcategory(
            name: "Need to update the e-mandate details",
            value: "FLM206",
            code: "7"),
        Subcategory(
            name: "Feedback on collection call", value: "FLM207", code: "8"),
        Subcategory(
            name: "Stop Marketing Communications", value: "FLM208", code: "9"),
        Subcategory(name: "Request for documents", value: "FLM209", code: "10"),
        Subcategory(
            name: "Need to update personal details",
            value: "FLM210",
            code: "11"),
        Subcategory(
            name: "Revoke consent already granted to collect personal data",
            value: "FLM211",
            code: "12"),
        Subcategory(
            name: "Delete/Forget existing data against my profile",
            value: "FLM212",
            code: "13"),
      ]),
  Category(name: 'Issue with Loan Payments', value: 'PAYMENTS', subCategories: [
    Subcategory(name: "EMI not executed", value: "PMT01", code: "1"),
    Subcategory(
        name: "Incorrect amount debited against the EMI",
        value: "PMT02",
        code: "2"),
    Subcategory(name: "EMI deducted twice", value: "PMT03", code: "3"),
    Subcategory(
        name: "Automatic debits not canceled after loan closure",
        value: "PMT04",
        code: "4"),
    Subcategory(
        name: "EMI payment not getting reflected", value: "PMT05", code: "5"),
    Subcategory(
        name: "Unable to prepay or make partpay", value: "PMT06", code: "6"),
    Subcategory(
        name: "Prepayment not reflecting in loan summary",
        value: "PMT07",
        code: "7"),
    Subcategory(
        name: "incorrect fees charged even during the cool-off period",
        value: "PMT08",
        code: "8"),
    Subcategory(
        name: "Loan completion certificate/NOC not received after full payment",
        value: "PMT09",
        code: "9"),
  ]),
  Category(
      name: 'Issue with Loan Interest and Charges',
      value: 'PAYMENTS',
      subCategories: [
        Subcategory(name: "RoI related issues", value: "PMT10", code: "10"),
        Subcategory(
            name: "Fees/Charges related issues", value: "PMT11", code: "11"),
      ]),
  Category(name: 'Generic Problem', value: 'ORDER', subCategories: [
    Subcategory(
        name: "Incorrect info on the credit report", value: "ORD01", code: "1"),
    Subcategory(
        name: "delay in updating payment information",
        value: "ORD0",
        code: "2"),
    Subcategory(
        name: "Missing or lost loan documents", value: "ORD03", code: "3"),
    Subcategory(
        name: "Errors in loan agreements or contracts",
        value: "ORD04",
        code: "4"),
  ]),
];
