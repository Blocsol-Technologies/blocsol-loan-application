import 'dart:async';

import 'package:blocsol_loan_application/global_state/auth/auth.dart';
import 'package:blocsol_loan_application/personal_loan/state/user/old_loan/http_controller.dart';
import 'package:blocsol_loan_application/personal_loan/state/user/old_loan/state/liability_state.dart';
import 'package:blocsol_loan_application/personal_loan/state/user/utils/loan/loan_details.dart';
import 'package:blocsol_loan_application/utils/http_service.dart';
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'old_loans.g.dart';

@riverpod
class PersonalLoanLiabilities extends _$PersonalLoanLiabilities {
  @override
  LiabilityStateData build() {
    ref.keepAlive();

    Timer.periodic(const Duration(seconds: 10), (_) async {
      await fetchOffers(CancelToken());
    });

    return LiabilityStateData(
        oldLoans: [],
        selectedOldOffer: PersonalLoanDetails.demoOffer(),
        fetchingOldOffers: false,
        oldOffersFetchTime: 0,
        initiatingForeclosure: false,
        initiatingPrepayment: false,
        prepaymentId: "",
        initiatingMissedEmiPayment: false,
        missedEmiPaymentId: "",
        missedEmiPaymentFailed: false,
        loanForeclosureFailed: false,
        prepaymentFailed: false);
  }

  void updateSelectedOffer(PersonalLoanDetails offer) {
    state = state.copyWith(selectedOldOffer: offer);
  }

  void updateMissedEmiPaymentId(String id) {
    state = state.copyWith(missedEmiPaymentId: id);
  }

  void reset() {
    ref.invalidateSelf();
  }

  // Fetch Old Loans
  Future<ServerResponse> fetchOffers(CancelToken cancelToken) async {
    var (authToken, _) = ref.read(authProvider.notifier).getAuthTokens();

    if (state.oldLoans.isEmpty) {
      state = state.copyWith(fetchingOldOffers: true);
    }

    var response = await PersonalLoanLiabilitiesHttpController()
        .fetchOffers(authToken, cancelToken);

    // Updating the fetch time in order to show no offers fetched message on frontend if no offers or error
    state = state.copyWith(
      fetchingOldOffers: false,
    );

    if (response.success) {
      if (DateTime.now().millisecondsSinceEpoch ~/ 1000 -
              state.oldOffersFetchTime >
          900) {
        state = state.copyWith(
            oldLoans: response.data,
            oldOffersFetchTime: DateTime.now().millisecondsSinceEpoch ~/ 1000);
      } else {
        state = state.copyWith(
          oldLoans: response.data,
        );
      }
    }

    return response;
  }

  Future<ServerResponse> refetchSelectedLoanOfferDetails(
      CancelToken cancelToken) async {
    var (authToken, _) = ref.read(authProvider.notifier).getAuthTokens();

    var response = await PersonalLoanLiabilitiesHttpController()
        .refetchSelectedLoanOfferDetails(state.selectedOldOffer.transactionId,
            state.selectedOldOffer.offerProviderId, authToken, cancelToken);

    if (response.success) {
      state = state.copyWith(
        selectedOldOffer: response.data,
      );
    }

    return response;
  }

  // Perform Status Request
  Future<ServerResponse> performStatusRequest(CancelToken cancelToken) async {
    var (authToken, _) = ref.read(authProvider.notifier).getAuthTokens();

    var response = await PersonalLoanLiabilitiesHttpController()
        .performStatusRequest(state.selectedOldOffer.transactionId,
            state.selectedOldOffer.offerProviderId, authToken, cancelToken);

    return response;
  }

  //Loan Foreclosure
  Future<ServerResponse> initiateForeclosure(CancelToken cancelToken) async {
    var (authToken, _) = ref.read(authProvider.notifier).getAuthTokens();

    state = state.copyWith(initiatingForeclosure: true);

    var response = await PersonalLoanLiabilitiesHttpController()
        .initiateForeclosure(state.selectedOldOffer.transactionId,
            state.selectedOldOffer.offerProviderId, authToken, cancelToken);

    state = state.copyWith(initiatingForeclosure: false);

    return response;
  }

  Future<ServerResponse> checkForeclosureSuccess(
      CancelToken cancelToken) async {
    var (authToken, _) = ref.read(authProvider.notifier).getAuthTokens();

    state = state.copyWith(loanForeclosureFailed: false);

    var response = await PersonalLoanLiabilitiesHttpController()
        .checkForeclosureSuccess(state.selectedOldOffer.transactionId,
            state.selectedOldOffer.offerProviderId, authToken, cancelToken);

    return response;
  }

  // Prepayment
  Future<ServerResponse> initiatePartPrepayment(
      String amount, CancelToken cancelToken) async {
    var (authToken, _) = ref.read(authProvider.notifier).getAuthTokens();

    state = state.copyWith(initiatingPrepayment: true);

    var response = await PersonalLoanLiabilitiesHttpController()
        .initiatePartPrepayment(amount, state.selectedOldOffer.transactionId,
            state.selectedOldOffer.offerProviderId, authToken, cancelToken);

    state = state.copyWith(
        initiatingPrepayment: false,
        prepaymentId: response.data['prepaymentId']);

    return response;
  }

  Future<ServerResponse> checkPrepaymentSuccess(CancelToken cancelToken) async {
    var (authToken, _) = ref.read(authProvider.notifier).getAuthTokens();

    state = state.copyWith(prepaymentFailed: false);

    var response = await PersonalLoanLiabilitiesHttpController()
        .checkPrepaymentSuccess(
            state.selectedOldOffer.transactionId,
            state.selectedOldOffer.offerProviderId,
            state.prepaymentId,
            authToken,
            cancelToken);

    return response;
  }

  // Missed EMI Payment
  Future<ServerResponse> initiateMissedEMIPayment(
      CancelToken cancelToken) async {
    var (authToken, _) = ref.read(authProvider.notifier).getAuthTokens();

    state = state.copyWith(initiatingMissedEmiPayment: true);

    var response = await PersonalLoanLiabilitiesHttpController()
        .initiateMissedEMIPayment(
            state.missedEmiPaymentId,
            state.selectedOldOffer.transactionId,
            state.selectedOldOffer.offerProviderId,
            authToken,
            cancelToken);

    state = state.copyWith(
        initiatingMissedEmiPayment: false,
        missedEmiPaymentId: response.data['missed_emi_id']);

    return response;
  }

  Future<ServerResponse> checkMissedEMIRepaymentSuccess(
      CancelToken cancelToken) async {
    var (authToken, _) = ref.read(authProvider.notifier).getAuthTokens();

    state = state.copyWith(missedEmiPaymentFailed: false);

    var response = await PersonalLoanLiabilitiesHttpController()
        .checkMissedEMIRepaymentSuccess(
            state.missedEmiPaymentId,
            state.selectedOldOffer.transactionId,
            state.selectedOldOffer.offerProviderId,
            authToken,
            cancelToken);

    return response;
  }
}
