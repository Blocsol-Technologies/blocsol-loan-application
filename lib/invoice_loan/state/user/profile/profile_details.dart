import 'package:blocsol_loan_application/global_state/auth/auth.dart';
import 'package:blocsol_loan_application/invoice_loan/state/user/profile/profile_http_controller.dart';
import 'package:blocsol_loan_application/invoice_loan/state/user/profile/state/bank_account.dart';
import 'package:blocsol_loan_application/invoice_loan/state/user/profile/state/profile_state.dart';
import 'package:blocsol_loan_application/utils/http_service.dart';
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_details.g.dart';

@riverpod
class InvoiceLoanUserProfileDetails extends _$InvoiceLoanUserProfileDetails {
  @override
  InvoiceLoanUserProfileData build() {
    ref.keepAlive();
    return InvoiceLoanUserProfileData.initial;
  }

  void reset() {
    ref.invalidateSelf();
  }

  void addBankAccount(BankAccountDetails bankAccount) {
    var accountNumber = bankAccount.accountNumber;
    var bankAccounts =
        List.from(state.bankAccounts) as List<BankAccountDetails>;

    var accountIndex = bankAccounts
        .indexWhere((element) => element.accountNumber == accountNumber);

    if (accountIndex == -1) {
      return;
    }

    bankAccounts[accountIndex] = bankAccount;

    state = state.copyWith(bankAccounts: bankAccounts);
  }

  bool setNotificationSeen(bool seen) {
    state = state.copyWith(notificationSeen: seen);

    return true;
  }

  int getNumUnseenNotifications() {
    return state.notifications
        .where((element) => !element.seen)
        .toList()
        .length;
  }

  void setPrimaryBankAccount(BankAccountDetails bankAccount) {
    addBankAccount(bankAccount);

    state = state.copyWith(primaryBankAccount: bankAccount);
  }

  void setDataConsentProvided(bool value) {
    state = state.copyWith(dataConsentProvided: value);
  }

  // Http Methods:

  // Fetch Company Details
  Future<ServerResponse> getCompanyDetails(CancelToken cancelToken) async {
    state = state.copyWith(fetchingData: true);

    var (_, authToken) = ref.read(authProvider.notifier).getAuthTokens();

    var response = await InvoiceLoanUserProfileDetailsHttpController()
        .getCompanyDetails(authToken, cancelToken);

    state = state.copyWith(fetchingData: false);

    if (response.success) {
      state = state.copyWith(
        gstNumber: response.data['gstNumber'],
        gstUsername: response.data['gstUsername'],
        email: response.data['email'],
        phone: response.data['phone'],
        businessLocation: response.data['businessLocation'],
        legalName: response.data['legalName'],
        tradeName: response.data['tradeName'],
        udyamNumber: response.data['udyamNumber'],
        dataConsentProvided: response.data['dataConsentProvided'],
        accountAggregatorSetup: response.data['accountAggregatorSetup'],
        bankAccounts: response.data['bankAccounts'],
        primaryBankAccount: response.data['primaryBankAccount'],
        accountAggregatorId: response.data['accountAggregatorId'],
        notificationSeen: response.data['notificationsSeen'],
        notifications: response.data['notifications'],
      );
    }

    return response;
  }

  Future<ServerResponse> updateCompanyBankAccountDetails(String accountNumber,
      String ifscCode, bool setPrimary, CancelToken cancelToken) async {
    var (_, authToken) = ref.read(authProvider.notifier).getAuthTokens();

    var response = await InvoiceLoanUserProfileDetailsHttpController()
        .updateBankAccountDetails(
            accountNumber, ifscCode, setPrimary, authToken, cancelToken);

    if (response.success) {
      if (setPrimary) {
        var bankAccount = BankAccountDetails(
          bankName: response.data['bankName'],
          accountNumber: response.data['accountNumber'],
          ifscCode: response.data['ifscCode'],
          accountHolderName: response.data['accountHolderName'],
        );

        setPrimaryBankAccount(bankAccount);
      } else {
        var bankAccount = BankAccountDetails(
          bankName: response.data['bankName'],
          accountNumber: response.data['accountNumber'],
          ifscCode: response.data['ifscCode'],
          accountHolderName: response.data['accountHolderName'],
        );

        addBankAccount(bankAccount);
      }
    }

    return response;
  }

  Future<ServerResponse> updateAccountAggregator(
      String accountAggregatorName, CancelToken cancelToken) async {
    var (_, authToken) = ref.read(authProvider.notifier).getAuthTokens();

    var response = await InvoiceLoanUserProfileDetailsHttpController()
        .updateAccountAggregator(accountAggregatorName, authToken, cancelToken);

    if (response.success) {
      String aaId = "${state.phone}@$accountAggregatorName";

      state = state.copyWith(accountAggregatorId: aaId);
    }

    return response;
  }

  Future<ServerResponse> changeAccountPassword(
      String oldPassword, String newPassword, CancelToken cancelToken) async {
    var (_, authToken) = ref.read(authProvider.notifier).getAuthTokens();

    var response = await InvoiceLoanUserProfileDetailsHttpController()
        .changeAccountPassword(
            oldPassword, newPassword, authToken, cancelToken);

    return response;
  }

  Future<ServerResponse> markNotificationsRead(
      String deviceId, CancelToken cancelToken) async {
    var (_, authToken) = ref.read(authProvider.notifier).getAuthTokens();

    var response = await InvoiceLoanUserProfileDetailsHttpController()
        .markNotificationsRead(deviceId, authToken, cancelToken);

    return response;
  }
}
