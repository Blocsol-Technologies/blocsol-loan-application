class Category {
  final String name;
  final String value;
  final List<String> subCategories;
  Category(
      {required this.name, required this.value, required this.subCategories});
}

List<Category> categories = [
  Category(name: 'Issue with Loan Process', value: 'ORDER', subCategories: [
    "NA",
    "Not able to complete the KYC",
    "Not able to set up E-mandate",
    "OTP not received during the e-sign of agreement",
    "Not able to view the agreement",
    "Need to update the e-mandate details",
    "Feedback on collection call",
    "Stop Marketing Communications",
    "Request for documents",
    "Need to update personal details",
    "revoke consent already granted to collect personal data",
    "delete/forget existing data against my profile",
    "Fees/Charges related issues",
    "Cibil Related",
  ]),
  Category(
      name: 'Issue with Loan Delivery by lender',
      value: 'FULFILLMENT',
      subCategories: [
        "NA",
        "Delay in disbursement/not disbursed",
        "Incorrect amount disbursed",
      ]),
  Category(name: 'Issues with Loan Payments', value: 'PAYMENT', subCategories: [
    "NA",
    "EMI not executed",
    "EMI wrongly executed",
    "EMI payment not getting reflected",
    "Preclosure/Part payment related",
    "NOC/Loan completion Related",
    "RoI related issues",
    "Loan Servicing"
  ]),
];
