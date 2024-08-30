import 'package:blocsol_loan_application/invoice_loan/state/user/profile/state/bank_account.dart';
import 'package:blocsol_loan_application/invoice_loan/state/user/profile/state/notification.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_state.freezed.dart';

@freezed
class InvoiceLoanUserProfileData with _$InvoiceLoanUserProfileData {
  const factory InvoiceLoanUserProfileData({
    required bool dataConsentProvided,
    required String gstNumber,
    required String gstUsername,
    required String email,
    required String phone,
    required String udyamNumber,
    required String legalName,
    required String tradeName,
    required String businessLocation,
    required bool accountAggregatorSetup,
    required String accountAggregatorId,
    required List<BankAccountDetails> bankAccounts,
    required BankAccountDetails primaryBankAccount,
    required List<IbcNotification> notifications,
    required bool notificationSeen,
    required bool fetchingData,
  }) = _InvoiceLoanUserProfileData;

  static InvoiceLoanUserProfileData initial = InvoiceLoanUserProfileData(
    dataConsentProvided: false,
    gstNumber: 'Loading...',
    gstUsername: 'Loading...',
    email: 'Loading...',
    phone: 'Loading...',
    udyamNumber: 'Loading...',
    legalName: 'Loading...',
    tradeName: 'Loading...',
    businessLocation: 'Loading...',
    bankAccounts: [],
    primaryBankAccount: BankAccountDetails(
      bankName: 'Loading...',
      accountNumber: 'Loading...',
      ifscCode: 'Loading...',
      accountHolderName: 'Loading...',
    ),
    accountAggregatorId: 'Loading...',
    accountAggregatorSetup: false,
    notifications: [],
    notificationSeen: false,
    fetchingData: false,
  );
}
