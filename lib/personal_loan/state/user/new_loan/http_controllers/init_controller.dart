import 'package:blocsol_loan_application/utils/errors.dart';
import 'package:blocsol_loan_application/utils/http_service.dart';
import 'package:dio/dio.dart';

class PersonalLoanRequestInitController {
  final httpService = HttpService(service: ServiceType.PersonalLoan);

  Future<ServerResponse> fetchAadharKYCURL(String transactionId,
      String providerId, String authToken, CancelToken cancelToken) async {
    try {
      var response = await httpService
          .post("/ondc/fetch-form-03", authToken, cancelToken, {
        "transaction_id": transactionId,
        "provider_id": providerId,
      });

      if (response.data['success']) {
        return ServerResponse(
            success: true,
            message: response.data['message'],
            data: {
              "url": response.data['data']['url'],
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
          success: false,
          message: e.response?.data['message'],
        );
      }

      return ServerResponse(
          success: false, message: "service unavailable. Try again later!");
    }
  }

  Future<ServerResponse> checkAadharKYCSuccess(String transactionId,
      String providerId, String authToken, CancelToken cancelToken) async {
    try {
      var response = await httpService.post(
          "/ondc/check-form-03-submission-success", authToken, cancelToken, {
        "transaction_id": transactionId,
        "provider_id": providerId,
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
          success: false, message: "service unavailable. Try again later!");
    }
  }

  Future<ServerResponse> refetchAadharKYCURL(String transactionId,
      String providerId, String authToken, CancelToken cancelToken) async {
    try {
      var response = await httpService.post(
          "/ondc/refetch-form-03-submission-url", authToken, cancelToken, {
        "transaction_id": transactionId,
        "provider_id": providerId,
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
          success: false, message: "service unavailable. Try again later!");
    }
  }

  Future<ServerResponse> verifyBankAccountDetails(
      String bankType,
      String bankAccountNumber,
      String bankIFSC,
      String transactionId,
      String providerId,
      String authToken,
      CancelToken cancelToken) async {
    try {
      var response = await httpService
          .post("/ondc/submit-form-04", authToken, cancelToken, {
        "transaction_id": transactionId,
        "provider_id": providerId,
        "bank_account_number": bankAccountNumber,
        "ifsc_code": bankIFSC,
        "bank_account_type": bankType,
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
          success: false, message: "service unavailable. Try again later!");
    }
  }

  Future<ServerResponse> fetchRepaymentURL(String transactionId,
      String providerId, String authToken, CancelToken cancelToken) async {
    try {
      var response = await httpService
          .post("/ondc/fetch-form-05-url", authToken, cancelToken, {
        "transaction_id": transactionId,
        "provider_id": providerId,
      });

      if (response.data['success']) {
        return ServerResponse(
          success: true,
          message: response.data['message'],
          data: {
            "url": response.data['data']['url'],
          },
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
          success: false, message: "service unavailable. Try again later!");
    }
  }

  Future<ServerResponse> checkRepaymentSuccess(String transactionId,
      String providerId, String authToken, CancelToken cancelToken) async {
    try {
      var response = await httpService.post(
          "/ondc/check-form-05-submission-success", authToken, cancelToken, {
        "transaction_id": transactionId,
        "provider_id": providerId,
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
          success: false, message: "service unavailable. Try again later!");
    }
  }

  Future<ServerResponse> refetchRepaymentSetupURL(String transactionId,
      String providerId, String authToken, CancelToken cancelToken) async {
    try {
      var response = await httpService.post(
          "/ondc/refetch-form-05-submission-url", authToken, cancelToken, {
        "transaction_id": transactionId,
        "provider_id": providerId,
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
          success: false, message: "service unavailable. Try again later!");
    }
  }

  Future<ServerResponse> fetchLoanAgreementURL(String transactionId,
      String providerId, String authToken, CancelToken cancelToken) async {
    try {
      var response = await httpService
          .post("/ondc/fetch-form-06", authToken, cancelToken, {
        "transaction_id": transactionId,
        "provider_id": providerId,
      });

      if (response.data['success']) {
        return ServerResponse(
            success: true,
            message: response.data['message'],
            data: {
              "url": response.data['data']['url'],
              "redirect_form": (response.data['data']['mimeType'] ?? "") ==
                  "application/html",
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
          success: false,
          message: e.response?.data['message'],
        );
      }

      return ServerResponse(
          success: false, message: "service unavailable. Try again later!");
    }
  }

  Future<ServerResponse> checkLoanAgreementSuccess(String transactionId,
      String providerId, String authToken, CancelToken cancelToken) async {
    try {
      var response = await httpService.post(
          "/ondc/check-form-06-submission-success", authToken, cancelToken, {
        "transaction_id": transactionId,
        "provider_id": providerId,
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
          success: false, message: "service unavailable. Try again later!");
    }
  }

  Future<ServerResponse> submitLoanAgreementAndCheckSuccess(
      String otp,
      String transactionId,
      String providerId,
      String authToken,
      CancelToken cancelToken) async {
    try {
      var response = await httpService
          .post("/ondc/submit-form-06", authToken, cancelToken, {
        "transaction_id": transactionId,
        "provider_id": providerId,
        "otp": otp,
      });

      if (!response.data['success']) {
        return ServerResponse(
          success: false,
          message: response.data['message'],
        );
      }

      bool success = false;
      int tries = 0;

      while (!success && tries < 5) {
        var checkSubmissionSuccessResponse = await checkLoanAgreementSuccess(
            transactionId, providerId, authToken, cancelToken);

        if (checkSubmissionSuccessResponse.success) {
          success = true;
        } else {
          tries++;
          await Future.delayed(const Duration(seconds: 10));
        }
      }

      if (success) {
        return ServerResponse(
          success: true,
          message: "Loan Agreement Submitted Successfully",
        );
      } else {
        return ServerResponse(
          success: false,
          message: "Loan Agreement Submission Failed",
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
          success: false, message: "service unavailable. Try again later!");
    }
  }

  Future<ServerResponse> refetchLoanAgreementURL(String transactionId,
      String providerId, String authToken, CancelToken cancelToken) async {
    try {
      var response = await httpService.post(
          "/ondc/refetch-form-06-submission-url", authToken, cancelToken, {
        "transaction_id": transactionId,
        "provider_id": providerId,
      });

      if (!response.data['success']) {
        return ServerResponse(
          success: false,
          message: response.data['message'],
        );
      }

      bool success = false;
      int tries = 0;

      while (!success && tries < 5) {
        var checkSubmissionSuccessResponse = await checkLoanAgreementSuccess(
            transactionId, providerId, authToken, cancelToken);

        if (checkSubmissionSuccessResponse.success) {
          success = true;
        } else {
          tries++;
          await Future.delayed(const Duration(seconds: 10));
        }
      }

      if (success) {
        return ServerResponse(
          success: true,
          message: "Loan Agreement Submitted Successfully",
        );
      } else {
        return ServerResponse(
          success: false,
          message: "Loan Agreement Submission Failed",
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
          success: false, message: "service unavailable. Try again later!");
    }
  }
}
