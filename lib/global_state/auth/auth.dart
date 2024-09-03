import 'package:blocsol_loan_application/global_state/auth/auth_state.dart';
import 'package:blocsol_loan_application/invoice_loan/state/auth/login/login.dart';
import 'package:blocsol_loan_application/invoice_loan/state/auth/signup/signup.dart';
import 'package:blocsol_loan_application/invoice_loan/state/events/loan_events/loan_events.dart';
import 'package:blocsol_loan_application/invoice_loan/state/events/server_sent_events/sse.dart';
import 'package:blocsol_loan_application/invoice_loan/state/loans/liability/all/all_liabilities.dart';
import 'package:blocsol_loan_application/invoice_loan/state/loans/loan_request/loan_request.dart';
import 'package:blocsol_loan_application/invoice_loan/state/support/support.dart';
import 'package:blocsol_loan_application/invoice_loan/state/ui/nav/bottom_nav_bar/bottom_nav_state.dart';
import 'package:blocsol_loan_application/invoice_loan/state/user/liability_details/liability_details.dart';
import 'package:blocsol_loan_application/invoice_loan/state/user/profile/profile_details.dart';
import 'package:blocsol_loan_application/personal_loan/state/auth/login/login.dart';
import 'package:blocsol_loan_application/personal_loan/state/auth/signup/signup.dart';
import 'package:blocsol_loan_application/personal_loan/state/nav/user/bottom_nav_bar/bottom_nav_bar_state.dart';
import 'package:blocsol_loan_application/personal_loan/state/user/account_details/account_details.dart';
import 'package:blocsol_loan_application/personal_loan/state/user/events/loan_events/loan_events.dart';
import 'package:blocsol_loan_application/personal_loan/state/user/events/server_sent_events/sse.dart';
import 'package:blocsol_loan_application/personal_loan/state/user/new_loan/new_loan.dart';
import 'package:blocsol_loan_application/personal_loan/state/user/old_loan/old_loans.dart';
import 'package:blocsol_loan_application/personal_loan/state/user/support/support.dart';
import 'package:blocsol_loan_application/utils/secure_storage.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

part 'auth.g.dart';

@riverpod
class Auth extends _$Auth {
  @override
  Future<AuthState?> build() async {
    String? personalLoanToken = await SecureStorage.read('personal-loan-token');
    String? invoiceLoanToken = await SecureStorage.read('invoice-loan-token');

    ref.keepAlive();
    return AuthState(
      personalLoanToken: personalLoanToken ?? "",
      invoiceLoanToken: invoiceLoanToken ?? "",
    );
  }

  (String, String) getAuthTokens() {
    String personalLoanToken = state.value?.personalLoanToken ?? "";
    String invoiceLoanToken = state.value?.invoiceLoanToken ?? "";

    bool personalLoanTokenExpired = checkIfTokenExpired(personalLoanToken);
    bool invoiceLoanTokenExpired = checkIfTokenExpired(invoiceLoanToken);

    return (
      !personalLoanTokenExpired ? personalLoanToken : "",
      !invoiceLoanTokenExpired ? invoiceLoanToken : ""
    );
  }

  Future<void> setInvoiceLoanAuthToken(String token) async {
    await SecureStorage.write('invoice-loan-token', token);
    String personalLoanToken = state.value?.personalLoanToken ?? "";

    state = AsyncValue.data(AuthState(
        invoiceLoanToken: token, personalLoanToken: personalLoanToken));
  }

  Future<void> setPersonalLoanAuthToken(String token) async {
    await SecureStorage.write('personal-loan-token', token);
    String invoiceLoanToken = state.value?.invoiceLoanToken ?? "";

    state = AsyncValue.data(AuthState(
        invoiceLoanToken: invoiceLoanToken, personalLoanToken: token));
  }

  Future<void> invalidateInvoiceLoanProviders() async {
    await SecureStorage.delete("invoice-loan-token");
  }

  Future<void> invalidatePersonalLoanProviders() async {
    await SecureStorage.delete("personal-loan-token");
  }

  Future<void> logoutInvoiceLoanUser() async {
    await invalidateInvoiceLoanProviders();
    String personalLoanToken = state.value?.personalLoanToken ?? "";

    state = AsyncValue.data(
        AuthState(invoiceLoanToken: "", personalLoanToken: personalLoanToken));

    ref.read(invoiceLoanLoginProvider.notifier).reset();
    ref.read(invoiceLoanSignupStateProvider.notifier).reset();
    ref.read(invoiceLoanEventsProvider.notifier).reset();
    ref.read(invoiceLoanServerSentEventsProvider.notifier).reset();
    ref.read(invoiceLoanLiabilitiesProvider.notifier).reset();
    ref.read(invoiceNewLoanRequestProvider.notifier).reset();
    ref.read(invoiceLoanSupportProvider.notifier).reset();
    ref.read(invoiceLoanBottomNavStateProvider.notifier).reset();
    ref.read(invoiceLoanUserLiabilityDetailsProvider.notifier).reset();
    ref.read(invoiceLoanUserProfileDetailsProvider.notifier).reset();
  }

  Future<void> logoutPersonalLoanUser() async {
    await invalidatePersonalLoanProviders();
    String invoiceLoanToken = state.value?.invoiceLoanToken ?? "";

    state = AsyncValue.data(
        AuthState(invoiceLoanToken: invoiceLoanToken, personalLoanToken: ""));

    ref.read(personalLoginStateProvider.notifier).reset();
    ref.read(personalLoanSignupProvider.notifier).reset();
    ref.read(personalLoanBottomNavStateProvider.notifier).reset();
    ref.read(personalLoanAccountDetailsProvider.notifier).reset();
    ref.read(personalLoanEventsProvider.notifier).reset();
    ref.read(personalLoanServerSentEventsProvider.notifier).reset();
    ref.read(personalNewLoanRequestProvider.notifier).reset();
    ref.read(personalLoanLiabilitiesProvider.notifier).reset();
    ref.read(personalLoanSupportStateProvider.notifier).reset();
  }
}

bool checkIfTokenExpired(String token) {
  try {
    if (token.isEmpty) {
      return true;
    }

    return JwtDecoder.isExpired(token);
  } catch (e) {
    return true;
  }
}
