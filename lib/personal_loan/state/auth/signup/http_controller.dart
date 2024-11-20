import 'package:blocsol_loan_application/utils/errors.dart';
import 'package:blocsol_loan_application/utils/http_service.dart';
import 'package:dio/dio.dart';

class PersonalLoanSignupHttpController {
  final HttpService httpService =
      HttpService(service: ServiceType.PersonalLoan);

  Future<ServerResponse> sendMobileOtp(
      String phoneNumber, String deviceId, CancelToken cancelToken) async {
    try {
      var response = await httpService.post("/signup/mobile-validation/send-otp",
          "", cancelToken, {"phoneNumber": phoneNumber, "signature": deviceId});

      if (response.data['success']) {
        return ServerResponse(
          success: true,
          message: response.data['message'],
        );
      } else {
        return ServerResponse(
          success: false,
          message: response.data['message'],
        );
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

  Future<ServerResponse> verifyMobileOTP(String phoneNumber, String otp,
      String email, String imageURL, CancelToken cancelToken) async {
    try {
      var response = await httpService.post(
          "/signup/mobile-validation/verify-otp", "", cancelToken, {
        "phoneNumber": phoneNumber,
        "otp": otp,
        "email": email,
        "imageURL": imageURL
      });

      if (response.data['success']) {
        return ServerResponse(
          success: true,
          message: response.data['message'],
        );
      } else {
        return ServerResponse(
          success: false,
          message: response.data['message'],
        );
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

  Future<ServerResponse> setPersonalDetails(String firstName, String lastName,
      String dob, String gender, String pan, CancelToken cancelToken) async {
    try {
      var response = await httpService
          .post("/signup/personal-details-authentication", "", cancelToken, {
        "phoneNumber": "8360458365",
        "firstName": firstName,
        "lastName": lastName,
        "dob": dob,
        "gender": gender.toLowerCase(),
        "pan": pan
      });

      if (response.data['success']) {
        return ServerResponse(
          success: true,
          message: response.data['message'],
        );
      } else {
        return ServerResponse(
          success: false,
          message: response.data['message'],
        );
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

  Future<ServerResponse> verifyUdyamNumber(
      String phoneNumber, String udyam, CancelToken cancelToken) async {
    try {
      var response = await httpService
          .post("/signup/udyam-verification", "", cancelToken, {
        "phoneNumber": phoneNumber,
        "udyam": udyam,
      });
      if (response.data['success']) {
        return ServerResponse(
          success: true,
          message: response.data['message'],
          data: response.data['companyName'] ?? "",
        );
      } else {
        return ServerResponse(
          success: false,
          message: response.data['message'],
        );
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

  Future<ServerResponse> addAddressDetails(
      String phoneNumber,
      String address,
      String city,
      String stateVal,
      String pincode,
      CancelToken cancelToken) async {
    try {
      var response = await httpService
          .post("/signup/address-details-authentication", "", cancelToken, {
        "phoneNumber": phoneNumber,
        "firstLine": address,
        "secondLine": address,
        "city": city,
        "state": stateVal,
        "pincode": pincode,
      });

      if (response.data['success']) {
        return ServerResponse(
          success: true,
          message: response.data['message'],
        );
      } else {
        return ServerResponse(
          success: false,
          message: response.data['message'],
        );
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

  Future<ServerResponse> setPassword(
      String phoneNumber, String password, CancelToken cancelToken) async {
    try {
      var response = await httpService
          .post("/signup/final-registration", "", cancelToken, {
        "phoneNumber": phoneNumber,
        "password": password,
      });

      if (response.data['success']) {
        return ServerResponse(
          success: true,
          message: response.data['message'],
          data: response.data['data']['token'],
        );
      } else {
        return ServerResponse(
          success: false,
          message: response.data['message'],
        );
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
