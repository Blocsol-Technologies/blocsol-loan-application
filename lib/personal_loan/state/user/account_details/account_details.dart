import 'package:blocsol_loan_application/global_state/auth/auth.dart';
import 'package:blocsol_loan_application/personal_loan/state/user/account_details/http_controller.dart';
import 'package:blocsol_loan_application/personal_loan/state/user/account_details/state/account_details_state.dart';
import 'package:blocsol_loan_application/personal_loan/state/user/account_details/state/bank_account_details.dart';
import 'package:blocsol_loan_application/personal_loan/state/user/account_details/state/notifications.dart';
import 'package:blocsol_loan_application/utils/http_service.dart';
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'account_details.g.dart';

@riverpod
class PersonalLoanAccountDetails extends _$PersonalLoanAccountDetails {
  @override
  AccountDetailsData build() {
    ref.keepAlive();
    return AccountDetailsData.initial;
  }

  void reset() {
    ref.invalidateSelf();
  }

  void addBankAccount(PlBankAccountDetails bankAccount) {
    var accountNumber = bankAccount.accountNumber;
    var bankAccounts =
        List.from(state.bankAccounts) as List<PlBankAccountDetails>;

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

  void setPrimaryBankAccount(PlBankAccountDetails bankAccount) {
    addBankAccount(bankAccount);

    state = state.copyWith(primaryBankAccount: bankAccount);
  }

  // Backend Functionality ================================================

  /* Get Borrower Details */

  Future<ServerResponse> getBorrowerDetails(CancelToken cancelToken) async {
    var (authToken, _) = ref.read(authProvider.notifier).getAuthTokens();

    var response = await PersonalLoanAccountDetailsHttpController()
        .getBorrowerDetails(authToken, cancelToken);

    if (response.success) {
      state = state.copyWith(
        name: response.data['name'],
        imageURL: response.data['imageURL'],
        dob: response.data['dob'],
        gender: response.data['gender'],
        pan: response.data['pan'],
        phone: response.data['phone'],
        email: response.data['email'],
        udyam: response.data['udyamNumber'],
        companyName: response.data['companyName'],
        address: response.data['address'],
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
      String ifscCode, bool setPrimary, int accountType, CancelToken cancelToken) async {
    var (authToken, _) = ref.read(authProvider.notifier).getAuthTokens();

    var response = await PersonalLoanAccountDetailsHttpController()
        .updateBankAccountDetails(
            accountNumber, ifscCode, setPrimary, accountType, authToken, cancelToken);

    if (response.success) {
      if (setPrimary) {
        var bankAccount = PlBankAccountDetails(
          bankName: response.data['bankName'],
          accountNumber: response.data['accountNumber'],
          ifscCode: response.data['ifscCode'],
          accountHolderName: response.data['accountHolderName'],
        );

        setPrimaryBankAccount(bankAccount);
      } else {
        var bankAccount = PlBankAccountDetails(
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
    var (authToken, _) = ref.read(authProvider.notifier).getAuthTokens();

    var response = await PersonalLoanAccountDetailsHttpController()
        .updateAccountAggregator(accountAggregatorName, authToken, cancelToken);

    if (response.success) {
      String aaId = "${state.phone}@$accountAggregatorName";

      state = state.copyWith(accountAggregatorId: aaId);
    }

    return response;
  }

  Future<ServerResponse> changeAccountPassword(
      String oldPassword, String newPassword, CancelToken cancelToken) async {
    var (authToken, _) = ref.read(authProvider.notifier).getAuthTokens();

    var response = await PersonalLoanAccountDetailsHttpController()
        .changeAccountPassword(
            oldPassword, newPassword, authToken, cancelToken);

    return response;
  }

  Future<ServerResponse> markNotificationsRead(
      String deviceId, CancelToken cancelToken) async {
    var (authToken, _) = ref.read(authProvider.notifier).getAuthTokens();

    var response = await PersonalLoanAccountDetailsHttpController()
        .markNotificationsRead(deviceId, authToken, cancelToken);

    if (response.success) {
      List<PlNotification> newNotifications = [];

      for (var notification in state.notifications) {
        notification.markRead(true);
        newNotifications.add(notification);
      }

      state = state.copyWith(
          notificationSeen: true, notifications: newNotifications);
    }

    return response;
  }
}
