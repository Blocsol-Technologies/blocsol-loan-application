import 'package:blocsol_loan_application/global_state/auth/auth.dart';
import 'package:blocsol_loan_application/invoice_loan/state/user/liability_details/liability_details_http_controller.dart';
import 'package:blocsol_loan_application/invoice_loan/state/user/liability_details/state/liability_details_state.dart';
import 'package:blocsol_loan_application/utils/http_service.dart';
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'liability_details.g.dart';

@riverpod
class InvoiceLoanUserLiabilityDetails
    extends _$InvoiceLoanUserLiabilityDetails {
  @override
  InvoiceLoanUserLiabilityData build() {
    ref.keepAlive();
    return InvoiceLoanUserLiabilityData.initial;
  }

  void reset() {
    ref.invalidateSelf();
  }

  void optimisticUpdateLiabilitiesValues(num value) {
    state = state.copyWith(
        numOutstandingValue: state.numOutstandingValue - value,
        numClosedValue: state.numClosedValue + value);
  }

  void optimisticUpdateNumLiabilities() {
    state = state.copyWith(
        numOpenLiabilities: state.numOpenLiabilities - 1,
        numClosedValue: state.numClosedLiabilities + 1);
  }


  // Http Methods:

  // Fetch Company Details
  Future<ServerResponse> getLiabilityDetails(CancelToken cancelToken) async {
    state = state.copyWith(fetchingLiabilityDetails: true);

    var (_, authToken) = ref.read(authProvider.notifier).getAuthTokens();

    var response =
        await InvoiceLoanLiabilityDetailsHttpController().getLiabilityDetails(
            authToken, cancelToken);

    state = state.copyWith(fetchingLiabilityDetails: false);

    if (response.success) {
      state = state.copyWith(
        numOpenLiabilities: response.data['totalOutstandingLoans'],
        numClosedLiabilities: response.data['totalClosedLoans'],
        numOutstandingValue: response.data['totalOutstandingValue'],
        numClosedValue: response.data['totalClosedValue'],
      );
    }

    return response;
  }
}
