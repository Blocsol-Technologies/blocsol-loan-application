import 'package:blocsol_loan_application/global_state/auth/auth.dart';
import 'package:blocsol_loan_application/personal_loan/state/user/account_details/http_controller.dart';
import 'package:blocsol_loan_application/personal_loan/state/user/account_details/state/account_details_state.dart';
import 'package:blocsol_loan_application/utils/http_service.dart';
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'account_details.g.dart';

@riverpod
class PersonalLoanAccountDetails extends _$PersonalLoanAccountDetails {
  @override
  AccountDetailsData build() {
    ref.keepAlive();
    return AccountDetailsData(
      name: "",
      imageURL: "",
      email: "",
      phone: "",
      gender: "",
      dob: "",
      address: Address.getNew(),
      pan: "",
      udyam: "",
      companyName: "",
      notifications: NotificationsData.getNew(),
    );
  }

  void reset() {
    state = AccountDetailsData(
      name: "",
      imageURL: "",
      email: "",
      phone: "",
      gender: "",
      dob: "",
      address: Address.getNew(),
      pan: "",
      udyam: "",
      companyName: "",
      notifications: NotificationsData.getNew(),
    );
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
        notifications: response.data['notifications'],
        udyam: response.data['udyamNumber'],
        companyName: response.data['companyName'],
        address: response.data['address'],
      );
    }

    return response;
  }
}
