import 'package:blocsol_loan_application/global_state/auth/auth_state.dart';
import 'package:blocsol_loan_application/invoice_loan/state/auth/login/login.dart';
import 'package:blocsol_loan_application/invoice_loan/state/events/loan_events/loan_events.dart';
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
    // ref.read(invoiceLoanSig)
    ref.read(invoiceLoanEventsProvider.notifier).reset();
  }

  Future<void> logoutPersonalLoanUser() async {
    await invalidatePersonalLoanProviders();
    String invoiceLoanToken = state.value?.invoiceLoanToken ?? "";

    state = AsyncValue.data(
        AuthState(invoiceLoanToken: invoiceLoanToken, personalLoanToken: ""));
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
