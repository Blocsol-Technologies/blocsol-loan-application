import 'package:blocsol_loan_application/utils/common_misc.dart';
import 'package:blocsol_loan_application/utils/errors.dart';

class PlBankAccountDetails {
  final String bankName;
  final String accountNumber;
  final String ifscCode;
  final String accountHolderName;
  final BankAccountType accountType;

  PlBankAccountDetails({
    required this.bankName,
    required this.accountNumber,
    required this.ifscCode,
    required this.accountHolderName,
    this.accountType = BankAccountType.savings,
  });

  factory PlBankAccountDetails.fromJson(Map<String, dynamic> json) {
    try {
      return PlBankAccountDetails(
        bankName: json['bankName'] ?? "",
        accountNumber: json['accountNumber'] ?? "",
        ifscCode: json['ifscCode'] ?? "",
        accountHolderName: json['accountHolderName'] ?? "",
        accountType: json['accountType'] == 0
            ? BankAccountType.current
            : BankAccountType.savings,
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

  static PlBankAccountDetails demo() {
    return PlBankAccountDetails(
      bankName: "",
      accountNumber: "",
      ifscCode: "",
      accountHolderName: "",
    );
  }
}
