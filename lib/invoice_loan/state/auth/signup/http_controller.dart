import 'package:blocsol_loan_application/utils/errors.dart';
import 'package:blocsol_loan_application/utils/http_service.dart';
import 'package:dio/dio.dart';

class SignupHttpController {
  final httpService = HttpService(service: ServiceType.InvoiceLoan);

  Future<ServerResponse> sendMobileOtp(
      String phoneNumber, signature, CancelToken cancelToken) async {
    try {
      var response = await httpService.get(
          "/signup/mobile-validation/send-otp",
          "",
          cancelToken,
          {"phoneNumber": phoneNumber, "signature": signature});

      if (response.data['success']) {
        return ServerResponse(
          success: true,
          message: response.data['message'],
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
            success: false, message: e.response?.data['message']);
      }

      return ServerResponse(
          success: false,
          message: "Error occured when sending OTP! Contact Support...");
    }
  }

  Future<ServerResponse> verifyMobileOtp(
      String phoneNumber, otp, CancelToken cancelToken) async {
    try {
      var response = await httpService.get(
          "/signup/mobile-validation/verify-otp",
          "",
          cancelToken,
          {"phoneNumber": phoneNumber, "otp": otp});

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
            success: false, message: e.response?.data['message']);
      }

      return ServerResponse(
          success: false,
          message: "Error occured when verifying OTP! Contact Support...");
    }
  }

  Future<ServerResponse> sendEmailOtp(
      String email, CancelToken cancelToken) async {
    try {
      var response = await httpService.get("/signup/email-validation/send-otp",
          "", cancelToken, {"email": email});

      if (response.data['success']) {
        return ServerResponse(
            success: true,
            message: response.data['message'],
            data: response.data['data']['id']);
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
            success: false, message: e.response?.data['message']);
      }

      return ServerResponse(
          success: false,
          message: "Error occured when sending OTP! Contact Support...");
    }
  }

  Future<ServerResponse> verifyEmailOtp(
      String email,String otp, String otpId, String phoneNumber, CancelToken cancelToken) async {
    try {
      var response = await httpService.get(
          "/signup/email-validation/verify-otp",
          "",
          cancelToken,
          {"email": email, "otp": otp, "id": otpId, "phone": phoneNumber});

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
            success: false, message: e.response?.data['message']);
      }

      return ServerResponse(
          success: false,
          message: "Error occured when verifying OTP! Contact Support...");
    }
  }

  Future<ServerResponse> createPreliminaryProfile(
      String email, phoneNumber, CancelToken cancelToken) async {
    try {
      var response = await httpService.post("/signup/preliminary-registration",
          "", cancelToken, {"email": email, "phoneNumber": phoneNumber});

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
            success: false, message: e.response?.data['message']);
      }

      return ServerResponse(
          success: false,
          message:
              "Error occured when creating preliminary profile! Contact Support...");
    }
  }

  Future<ServerResponse> verifyGstNumber(
      String gst, phoneNumber, CancelToken cancelToken) async {
    try {
      var response = await httpService.post("/signup/gst-authentication", "",
          cancelToken, {"gst": gst, "phoneNumber": phoneNumber});

      if (response.data['success']) {
        return ServerResponse(
            success: true,
            message: response.data['message'],
            data: {
              "companyLegalName": response.data['data']['companyLegalName'],
              "businessLocation": response.data['data']['businessLocation'],
              "gstRegistrationDate": response.data['data']
                  ['gstRegistrationDate']
            });
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
            success: false, message: e.response?.data['message']);
      }

      return ServerResponse(
          success: false,
          message:
              "Error occured when verifying GST Number! Contact Support...");
    }
  }

  Future<ServerResponse> verifyUdyamNumber(
      String gst, udyam, CancelToken cancelToken) async {
    try {
      var response = await httpService.post("/signup/udyam-verification", "",
          cancelToken, {"gst": gst, "udyam": udyam});

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
            success: false, message: e.response?.data['message']);
      }

      return ServerResponse(
          success: false,
          message:
              "Error occured when verifying Udyam Number! Contact Support...");
    }
  }

  Future<ServerResponse> sendGstOtp(
      String gst, gstUsername, CancelToken cancelToken) async {
    try {
      var response = await httpService.post("/signup/gst-send-otp", "",
          cancelToken, {"gstNumber": gst, "gstUsername": gstUsername});

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
            success: false, message: e.response?.data['message']);
      }

      return ServerResponse(
          success: false,
          message: "Error occured when sending OTP! Contact Support...");
    }
  }

  Future<ServerResponse> verifyGstOtp(
      String gst, gstUsername, otp, CancelToken cancelToken) async {
    try {
      var response = await httpService.post(
          "/signup/gst-validate-otp",
          "",
          cancelToken,
          {"gstNumber": gst, "gstUsername": gstUsername, "otp": otp});

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
            success: false, message: e.response?.data['message']);
      }

      return ServerResponse(
          success: false,
          message: "Error occured when verifying OTP! Contact Support...");
    }
  }

  Future<ServerResponse> checkGstDataDownloadCompletion(
      String gst, CancelToken cancelToken) async {
    try {
      var response = await httpService.get(
          "/signup/gst-validation-completion-check",
          "",
          CancelToken(),
          {"gst": gst});

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
            success: false, message: e.response?.data['message']);
      }

      return ServerResponse(
          success: false,
          message:
              "Error occured when checking GST Data Download Completion! Contact Support...");
    }
  }

  Future<ServerResponse> setAccountPassword(
      String gst, password, CancelToken cancelToken) async {
    try {
      var response = await httpService.post("/signup/set-password", "",
          cancelToken, {"gst": gst, "password": password});

      if (response.data['success']) {
        return ServerResponse(
            success: true,
            message: response.data['message'],
            data: {"token": response.data['data']['token']});
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
            success: false, message: e.response?.data['message']);
      }

      return ServerResponse(
          success: false,
          message:
              "Error occured when setting account password! Contact Support...");
    }
  }
}
