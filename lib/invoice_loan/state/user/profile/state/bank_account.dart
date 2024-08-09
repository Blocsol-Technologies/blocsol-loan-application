import 'package:blocsol_loan_application/utils/errors.dart';

class BankAccountDetails {
  final String bankName;
  final String accountNumber;
  final String ifscCode;
  final String accountHolderName;

  BankAccountDetails({
    required this.bankName,
    required this.accountNumber,
    required this.ifscCode,
    required this.accountHolderName,
  });

  factory BankAccountDetails.fromJson(Map<String, dynamic> json) {
    try {
      return BankAccountDetails(
        bankName: json['bankName'] ?? "",
        accountNumber: json['accountNumber'] ?? "",
        ifscCode: json['ifscCode'] ?? "",
        accountHolderName: json['accountHolderName'] ?? "",
      );
    } catch (e, stackTrace) {
      ErrorInstance(
              message: "Err when parsing bank account information",
              exception: e,
              trace: stackTrace)
          .reportError();

      return demo();
    }
  }

  static BankAccountDetails demo() {
    return BankAccountDetails(
      bankName: "",
      accountNumber: "",
      ifscCode: "",
      accountHolderName: "",
    );
  }
}
