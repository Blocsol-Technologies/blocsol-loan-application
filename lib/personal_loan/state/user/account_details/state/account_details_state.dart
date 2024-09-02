import 'package:blocsol_loan_application/personal_loan/state/user/account_details/state/bank_account_details.dart';
import 'package:blocsol_loan_application/personal_loan/state/user/account_details/state/notifications.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'account_details_state.freezed.dart';

class Address {
  final String streetAddress;
  final String state;
  final String city;
  final String pincode;

  Address({
    this.streetAddress = "",
    this.state = "",
    this.city = "",
    this.pincode = "",
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    try {
      return Address(
          streetAddress: json['line1'] ?? "",
          state: json['state'] ?? "",
          city: json['city'] ?? "",
          pincode: json['pincode'] ?? "");
    } catch (e) {
      return Address();
    }
  }

  static Address getNew() {
    return Address();
  }
}

@freezed
class AccountDetailsData with _$AccountDetailsData {
  const factory AccountDetailsData({
    // Personal Details
    required String name,
    required String imageURL,
    required String email,
    required String phone,
    required String dob,
    required String gender,
    required Address address,
    required String pan,
    required String udyam,
    required String companyName,
    required bool accountAggregatorSetup,
    required String accountAggregatorId,
    required List<PlBankAccountDetails> bankAccounts,
    required PlBankAccountDetails primaryBankAccount,
    required List<PlNotification> notifications,
    required bool notificationSeen,
  }) = _AccountDetailsData;

  static AccountDetailsData initial = AccountDetailsData(
    name: "",
    imageURL: "",
    email: "",
    phone: "",
    dob: "",
    gender: "",
    address: Address.getNew(),
    pan: "",
    udyam: "",
    companyName: "",
    accountAggregatorSetup: false,
    accountAggregatorId: "",
    bankAccounts: [],
    primaryBankAccount: PlBankAccountDetails.demo(),
    notificationSeen: true,
    notifications: [],
  );
}
