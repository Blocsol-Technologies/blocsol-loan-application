import 'package:blocsol_loan_application/utils/errors.dart';
import 'package:blocsol_loan_application/utils/http_service.dart';
import 'package:dio/dio.dart';

class PersonalLoanLoginHttpController {
  final HttpService httpService =
      HttpService(service: ServiceType.PersonalLoan);

  Future<ServerResponse> validatePassword(String phoneNumber, String password,
      String deviceId, CancelToken cancelToken) async {
    try {
      var response = await httpService.post(
          "/login/validate-password", "", cancelToken, {
        "phoneNumber": phoneNumber,
        "password": password,
        "signature": deviceId
      });

      if (response.data['success']) {
        return ServerResponse(
          success: true,
          message: response.data['message'],
          data: response.data['data']['pan'] ?? "",
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
            success: false, message: e.response?.data['message'], data: null);
      }

      return ServerResponse(
          success: false,
          message:
              "error occured when validating password! Contact Support...");
    }
  }

  Future<ServerResponse> validateOtp(String phoneNumber, String otp, String pan,
      CancelToken cancelToken) async {
    try {
      var response = await httpService.post("/login/validate-otp", "",
          cancelToken, {"phoneNumber": phoneNumber, "otp": otp, "pan": pan});

      if (response.data['success']) {
        return ServerResponse(
            success: true,
            message: response.data['message'],
            data: response.data['data']['token']);
      } else {
        return ServerResponse(
            success: false, message: response.data['message']);
      }
    } catch (e, stackTrace) {
      ErrorInstance(
        message: "error occured when validating login otp",
        exception: e,
        trace: stackTrace,
      ).reportError();

      if (e is DioException) {
        return ServerResponse(
            success: false, message: e.response?.data['message'], data: null);
      }

      return ServerResponse(
          success: false,
          message:
              "error occured when validating login OTP! Contact Support...");
    }
  }
}
