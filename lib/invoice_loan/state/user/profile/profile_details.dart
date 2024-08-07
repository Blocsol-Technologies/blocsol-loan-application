import 'package:blocsol_loan_application/global_state/auth/auth.dart';
import 'package:blocsol_loan_application/invoice_loan/state/user/profile/profile_http_controller.dart';
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

  void setDataConsentProvided (bool value) {
    state = state.copyWith(dataConsentProvided: value);
  }

  // Http Methods:

  // Fetch Company Details
  Future<ServerResponse> getCompanyDetails(CancelToken cancelToken) async {
    state = state.copyWith(fetchingData: true);

    var (_, authToken) = ref.read(authProvider.notifier).getAuthTokens();

    var response = await InvoiceLoanUserProfileDetailsHttpController.getCompanyDetails(
        authToken, cancelToken);

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
      );
    }

    return response;
  }
}
