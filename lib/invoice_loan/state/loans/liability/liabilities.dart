import 'package:blocsol_loan_application/global_state/auth/auth.dart';
import 'package:blocsol_loan_application/invoice_loan/state/loans/liability/http_controller.dart';
import 'package:blocsol_loan_application/invoice_loan/state/loans/liability/state/liability_state.dart';
import 'package:blocsol_loan_application/invoice_loan/state/loans/loan_details.dart';
import 'package:blocsol_loan_application/utils/http_service.dart';
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'liabilities.g.dart';

@riverpod
class Liabilities extends _$Liabilities {
  @override
  LiabilitiesState build() {
    ref.keepAlive();
    return LiabilitiesState.initial;
  }

  void reset() {
    ref.invalidateSelf();
  }

  void updateSelectedOffer(LoanDetails details) {
    state = state.copyWith(selectedLiability: details);
  }

  void updateMissedEmiPaymentId(String id) {
    state = state.copyWith(missedEmiPaymentId: id);
  }

  Future<ServerResponse> fetchLiabilities(CancelToken cancelToken) async {
    var (_, authToken) = ref.read(authProvider.notifier).getAuthTokens();

    if (state.liabilities.isEmpty) {
      state = state.copyWith(fetchingLiabilitiess: true);
    }
    var response = await LiabilitiesHttpController.fetchLiabilities(
        authToken, cancelToken);

    state = state.copyWith(
        fetchingLiabilitiess: false,
        liabilitiessFetchTime: DateTime.now().millisecondsSinceEpoch ~/ 1000);

    if (response.success) {
      state = state.copyWith(
        liabilities: response.data,
      );

      if (DateTime.now().millisecondsSinceEpoch ~/ 1000 -
              state.liabilitiessFetchTime >
          900) {
        state = state.copyWith(
            liabilities: response.data,
            liabilitiessFetchTime:
                DateTime.now().millisecondsSinceEpoch ~/ 1000);
      } else {
        state = state.copyWith(
          liabilities: response.data,
        );
      }
    }
    return response;
  }

  Future<ServerResponse> fetchSingleLiabilityDetails(
      CancelToken cancelToken) async {
    var (_, authToken) = ref.read(authProvider.notifier).getAuthTokens();

    var transactionId = state.selectedLiability.offerDetails.transactionId;
    var providerId = state.selectedLiability.offerDetails.offerProviderId;

    if (transactionId.isEmpty || providerId.isEmpty) {
      return ServerResponse(
          success: false,
          message: "No transaction id or provider id in ths state",
          data: null);
    }

    state = state.copyWith(fetchingSingleLiabilityDetails: true);

    var response = await LiabilitiesHttpController.fetchSingleLiabilityDetails(
        transactionId, providerId, authToken, cancelToken);

    state = state.copyWith(fetchingSingleLiabilityDetails: false);

    if (response.success) {
      state = state.copyWith(
        selectedLiability: response.data,
      );
    }

    return response;
  }

  // Perform Status Request
  Future<ServerResponse> performStatusRequest(CancelToken cancelToken) async {
    var (_, authToken) = ref.read(authProvider.notifier).getAuthTokens();

    var transactionId = state.selectedLiability.offerDetails.transactionId;
    var providerId = state.selectedLiability.offerDetails.offerProviderId;

    if (transactionId.isEmpty || providerId.isEmpty) {
      return ServerResponse(
          success: false,
          message: "No transaction id or provider id in ths state",
          data: null);
    }

    return await LiabilitiesHttpController.performStatusRequest(
        transactionId, providerId, authToken, cancelToken);
  }

  //Loan Foreclosure
  Future<ServerResponse> initiateForeclosure(CancelToken cancelToken) async {
    var (_, authToken) = ref.read(authProvider.notifier).getAuthTokens();

    var transactionId = state.selectedLiability.offerDetails.transactionId;
    var providerId = state.selectedLiability.offerDetails.offerProviderId;

    if (transactionId.isEmpty || providerId.isEmpty) {
      return ServerResponse(
          success: false,
          message: "No transaction id or provider id in ths state",
          data: null);
    }

    state = state.copyWith(initiatingForeclosure: true);

    var response = await LiabilitiesHttpController.initiateForeclosure(
        transactionId, providerId, authToken, cancelToken);

    state = state.copyWith(initiatingForeclosure: false);

    return response;
  }

  Future<ServerResponse> checkForeclosureSuccess(
      CancelToken cancelToken) async {
    var (_, authToken) = ref.read(authProvider.notifier).getAuthTokens();

    var transactionId = state.selectedLiability.offerDetails.transactionId;
    var providerId = state.selectedLiability.offerDetails.offerProviderId;

    if (transactionId.isEmpty || providerId.isEmpty) {
      return ServerResponse(
          success: false,
          message: "No transaction id or provider id in ths state",
          data: null);
    }

    state = state.copyWith(loanForeclosureFailed: false);

    var response = await LiabilitiesHttpController.checkForeclosureSuccess(
        transactionId, providerId, authToken, cancelToken);

    if (!response.success) {
      state = state.copyWith(loanForeclosureFailed: true);
    }

    return response;
  }

  // Prepayment
  Future<ServerResponse> initiatePartPrepayment(
      String amount, CancelToken cancelToken) async {
    var (_, authToken) = ref.read(authProvider.notifier).getAuthTokens();

    var transactionId = state.selectedLiability.offerDetails.transactionId;
    var providerId = state.selectedLiability.offerDetails.offerProviderId;

    if (transactionId.isEmpty || providerId.isEmpty) {
      return ServerResponse(
          success: false,
          message: "No transaction id or provider id in ths state",
          data: null);
    }

    state = state.copyWith(initiatingPrepayment: true);

    var response = await LiabilitiesHttpController.initiatePartPrepayment(
        amount, transactionId, providerId, authToken, cancelToken);

    state = state.copyWith(initiatingPrepayment: false);

    if (response.success) {
      state = state.copyWith(prepaymentId: response.data['id']);
    }

    return response;
  }

  Future<ServerResponse> checkPrepaymentSuccess(CancelToken cancelToken) async {
    var (_, authToken) = ref.read(authProvider.notifier).getAuthTokens();

    var transactionId = state.selectedLiability.offerDetails.transactionId;
    var providerId = state.selectedLiability.offerDetails.offerProviderId;
    var prepaymentId = state.prepaymentId;

    if (transactionId.isEmpty || providerId.isEmpty || prepaymentId.isEmpty) {
      return ServerResponse(
          success: false,
          message: "No transaction id or provider id in ths state",
          data: null);
    }

    state = state.copyWith(prepaymentFailed: false);

    var response = await LiabilitiesHttpController.checkPrepaymentSuccess(
        prepaymentId, transactionId, providerId, authToken, cancelToken);

    if (!response.success) {
      state = state.copyWith(prepaymentFailed: true);
    }

    return response;
  }

  // Missed EMI Payment
  Future<ServerResponse> initiateMissedEMIPayment(
      CancelToken cancelToken) async {
    var (_, authToken) = ref.read(authProvider.notifier).getAuthTokens();

    var transactionId = state.selectedLiability.offerDetails.transactionId;
    var providerId = state.selectedLiability.offerDetails.offerProviderId;

    if (transactionId.isEmpty || providerId.isEmpty) {
      return ServerResponse(
          success: false,
          message: "No transaction id or provider id in ths state",
          data: null);
    }

    state = state.copyWith(initiatingMissedEmiPayment: true);

    var response = await LiabilitiesHttpController.initiateMissedEmiRepayment(
        state.missedEmiPaymentId,
        transactionId,
        providerId,
        authToken,
        cancelToken);

    state = state.copyWith(initiatingMissedEmiPayment: false);

    if (response.success) {
      state = state.copyWith(missedEmiPaymentId: response.data['id']);
    }

    return response;
  }

  Future<ServerResponse> checkMissedEMIRepaymentSuccess(
      CancelToken cancelToken) async {
    var (_, authToken) = ref.read(authProvider.notifier).getAuthTokens();

    var transactionId = state.selectedLiability.offerDetails.transactionId;
    var providerId = state.selectedLiability.offerDetails.offerProviderId;
    var missedEmiPaymentId = state.missedEmiPaymentId;

    if (transactionId.isEmpty ||
        providerId.isEmpty ||
        missedEmiPaymentId.isEmpty) {
      return ServerResponse(
          success: false,
          message: "No transaction id or provider id in ths state",
          data: null);
    }

    state = state.copyWith(missedEmiPaymentFailed: false);

    var response =
        await LiabilitiesHttpController.checkMissedEmiRepaymentSuccess(
            missedEmiPaymentId,
            transactionId,
            providerId,
            authToken,
            cancelToken);

    if (!response.success) {
      state = state.copyWith(missedEmiPaymentFailed: true);
    }

    return response;
  }
}
