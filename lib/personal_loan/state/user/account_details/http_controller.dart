import 'package:blocsol_loan_application/personal_loan/state/user/account_details/state/account_details_state.dart';
import 'package:blocsol_loan_application/utils/errors.dart';
import 'package:blocsol_loan_application/utils/http_service.dart';
import 'package:dio/dio.dart';

class PersonalLoanAccountDetailsHttpController {
  final HttpService httpService =
      HttpService(service: ServiceType.PersonalLoan);

  Future<ServerResponse> getBorrowerDetails(
      String authToken, CancelToken cancelToken) async {
    try {
      var response = await httpService.get(
          "/accounts/get-borrower-basic-details", authToken, cancelToken, {});

      if (response.data['success']) {
        Address address = Address.fromJson(response.data['data']['address']);
        NotificationsData notifications =
            NotificationsData.fromJson(response.data['data']['notifications']);

        return ServerResponse(
          success: true,
          message: response.data['message'],
          data: {
            "name":
                "${response.data['data']['firstName']} ${response.data['data']['lastName']}",
            "imageURL": response.data['data']['profilePicURL'],
            "dob": response.data['data']['dob'],
            "gender": response.data['data']['gender'],
            "pan": response.data['data']['pan'],
            "phone": response.data['data']['phone'],
            "email": response.data['data']['email'],
            "notifications": notifications,
            "udyamNumber": response.data['data']['udyamNumber'],
            "companyName": response.data['data']['companyName'],
            "address": address,
          },
        );
      } else {
        return ServerResponse(
            success: false, message: response.data['message']);
      }
    } catch (e, stackTrace) {
      ErrorInstance(
        message: e.toString(),
        exception: e,
        trace: stackTrace,
      ).reportError();

      if (e is DioException) {
        return ServerResponse(
          success: false,
          message: e.response?.data['message'],
        );
      }

      return ServerResponse(
          success: false, message: "Service unavailable! Contact Support...");
    }
  }
}
