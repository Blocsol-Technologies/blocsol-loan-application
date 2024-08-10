import 'package:blocsol_loan_application/utils/errors.dart';
import 'package:blocsol_loan_application/utils/http_service.dart';
import 'package:dio/dio.dart';

class LoanRequestInitHttpController {
  static Future<ServerResponse> performInitRequest(String transactionId,
      String providerId, String authToken, CancelToken cancelToken) async {
    try {
      var httpService = HttpService();
      var response = await httpService
          .post("/ondc/perform-init-request", authToken, cancelToken, {
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
        message:
            "Error occured when making the init request! Contact Support...",
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
          success: false,
          message:
              "Error occured when making the init request! Contact Support...");
    }
  }

  static Future<ServerResponse> fetchEntityKycForm(String transactionId,
      String providerId, String authToken, CancelToken cancelToken) async {
    try {
      var httpService = HttpService();
      var response = await httpService
          .post("/ondc/fetch-form-04", authToken, cancelToken, {
        "transaction_id": transactionId,
        "provider_id": providerId,
      });

      if (response.data['success']) {
        return ServerResponse(
            success: true,
            message: response.data['message'],
            data: {"url": response.data['data']?['url'] ?? ""});
      } else {
        return ServerResponse(
          success: false,
          message: response.data['message'],
        );
      }
    } catch (e, stackTrace) {
      ErrorInstance(
        message:
            "Error occured when fetching udyam kyc form! Contact Support...",
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
          success: false,
          message:
              "Error occured when fetching udyam kyc form! Contact Support...");
    }
  }

  static Future<ServerResponse> refetchEntityKycForm(String transactionId,
      String providerId, String authToken, CancelToken cancelToken) async {
    try {
      var httpService = HttpService();
      var response = await httpService.post(
          "/ondc/refetch-form-04-submission-url", authToken, cancelToken, {
        "transaction_id": transactionId,
        "provider_id": providerId,
      });
      if (response.data['success']) {
        return ServerResponse(
            success: true,
            message: response.data['message'],
            data: {"url": response.data['data']?['url'] ?? ""});
      } else {
        return ServerResponse(
          success: false,
          message: response.data['message'],
        );
      }
    } catch (e, stackTrace) {
      ErrorInstance(
        message:
            "Error occured when refetching udyam kyc form! Contact Support...",
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
          success: false,
          message:
              "Error occured when refetching udyam kyc form! Contact Support...");
    }
  }

  static Future<ServerResponse> checkEntityKycFormSuccess(String transactionId,
      String providerId, String authToken, CancelToken cancelToken) async {
    try {
      var httpService = HttpService();
      var response = await httpService.post(
          "/ondc/check-form-04-submission-success", authToken, cancelToken, {
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
        message:
            "Error occured when checking udyam kyc form success! Contact Support...",
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
          success: false,
          message:
              "Error occured when checking udyam kyc form success! Contact Support...");
    }
  }

  static Future<ServerResponse> fetchBankAccountFormDetails(
      String transactionId,
      String providerId,
      String authToken,
      CancelToken cancelToken) async {
    try {
      var httpService = HttpService();

      var response = await httpService
          .post("/ondc/get-bank-account-form-details", authToken, cancelToken, {
        "transaction_id": transactionId,
        "provider_id": providerId,
      });

      if (response.data['success']) {
        return ServerResponse(
            success: true,
            message: response.data['message'],
            data: {
              "account_number_readonly":
                  response.data['data']?['account_number_readonly'] ?? false,
              "account_number": response.data['data']?['account_number'] ?? "",
              "ifsc_readonly": response.data['data']?['ifsc_readonly'] ?? false,
              "ifsc": response.data['data']?['ifsc'] ?? "",
            });
      } else {
        return ServerResponse(
          success: false,
          message: response.data['message'],
        );
      }
    } catch (e, stackTrace) {
      ErrorInstance(
        message:
            "Error occured when fetching repayment setup url! Contact Support...",
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
          success: false,
          message:
              "Error occured when fetching repayment setup url! Contact Support...");
    }
  }

  static Future<ServerResponse> submitBankAccountDetails(
      String bankAccountNumber,
      String bankIfsc,
      String transactionId,
      String providerId,
      String authToken,
      CancelToken cancelToken) async {
    try {
      var httpService = HttpService();

      var submitResponse = await httpService
          .post("/ondc/submit-form-05", authToken, cancelToken, {
        "transaction_id": transactionId,
        "provider_id": providerId,
        "bank_account_number": bankAccountNumber,
        "ifsc_code": bankIfsc,
      });

      if (submitResponse.data['success']) {
        return ServerResponse(
          success: true,
          message: submitResponse.data['message'],
        );
      } else {
        return ServerResponse(
          success: false,
          message: submitResponse.data['message'],
        );
      }
    } catch (e, stackTrace) {
      ErrorInstance(
        message:
            "Error occured when submitting bank account details! Contact Support...",
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
          success: false,
          message:
              "Error occured when submitting bank account details! Contact Support...");
    }
  }

  static Future<ServerResponse> fetchRepaymentSetupUrl(String transactionId,
      String providerId, String authToken, CancelToken cancelToken) async {
    try {
      var httpService = HttpService();

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
              "url": response.data['data']?['url'] ?? "",
              "sanctionedCancellationFee":
                  response.data['data']?['sanctionedCancellationFee'] ?? ""
            });
      } else {
        return ServerResponse(
          success: false,
          message: response.data['message'],
        );
      }
    } catch (e, stackTrace) {
      ErrorInstance(
        message:
            "Error occured when fetching repayment setup url! Contact Support...",
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
          success: false,
          message:
              "Error occured when fetching repayment setup url! Contact Support...");
    }
  }

  static Future<ServerResponse> checkRepaymentSetupSuccess(String transactionId,
      String providerId, String authToken, CancelToken cancelToken) async {
    try {
      var httpService = HttpService();

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
        message:
            "Error occured when checking repayment setup success! Contact Support...",
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
          success: false,
          message:
              "Error occured when checking repayment setup success! Contact Support...");
    }
  }

  static Future<ServerResponse> refetchRepaymentSetupForm(String transactionId,
      String providerId, String authToken, CancelToken cancelToken) async {
    try {
      var httpService = HttpService();
      var response = await httpService.post(
          "/ondc/refetch-form-06-submission-url", authToken, cancelToken, {
        "transaction_id": transactionId,
        "provider_id": providerId,
      });

      if (response.data['success']) {
        return ServerResponse(
            success: true,
            message: response.data['message'],
            data: response.data['data']?['url'] ?? "");
      } else {
        return ServerResponse(
          success: false,
          message: response.data['message'],
        );
      }
    } catch (e, stackTrace) {
      ErrorInstance(
        message:
            "Error occured when refetching repayment setup form! Contact Support...",
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
          success: false,
          message:
              "Error occured when refetching repayment setup form! Contact Support...");
    }
  }

  static Future<ServerResponse> fetchLoanAgreementForm(String transactionId,
      String providerId, String authToken, CancelToken cancelToken) async {
    try {
      var httpService = HttpService();
      var response = await httpService
          .post("/ondc/fetch-form-07", authToken, cancelToken, {
        "transaction_id": transactionId,
        "provider_id": providerId,
      });

      if (response.data['success']) {
        return ServerResponse(
            success: true,
            message: response.data['message'],
            data: {
              "url": response.data['data']?['url'] ?? "",
              "redirect_form": response.data['data']?['redirect_form'] ?? false
            });
      } else {
        return ServerResponse(
          success: false,
          message: response.data['message'],
        );
      }
    } catch (e, stackTrace) {
      ErrorInstance(
        message:
            "Error occured when fetching loan agreement url! Contact Support...",
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
          success: false,
          message:
              "Error occured when fetching loan agreement url! Contact Support...");
    }
  }

  static Future<ServerResponse> submitLoanAgreementForm(
      String otp,
      String transactionId,
      String providerId,
      String authToken,
      CancelToken cancelToken) async {
    try {
      var httpService = HttpService();

      var response = await httpService.post(
          "/ondc/submit-form-07", authToken, cancelToken, {
        "transaction_id": transactionId,
        "provider_id": providerId,
        "otp": otp
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
        message:
            "Error occured when submitting loan agreement form! Contact Support...",
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
          success: false,
          message:
              "Error occured when submitting loan agreement form! Contact Support...");
    }
  }

  static Future<ServerResponse> checkLoanAgreementSuccess(String transactionId,
      String providerId, String authToken, CancelToken cancelToken) async {
    try {
      var httpService = HttpService();
      var response = await httpService.post(
          "/ondc/check-form-07-submission-success", authToken, cancelToken, {
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
        message:
            "Error occured when checking loan agreement success! Contact Support...",
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
          success: false,
          message:
              "Error occured when checking loan agreement success! Contact Support...");
    }
  }

  static Future<ServerResponse> refetchLoanAgreementForm(String transactionId,
      String providerId, String authToken, CancelToken cancelToken) async {
    try {
      var httpService = HttpService();

      var response = await httpService.post(
          "/ondc/refetch-form-07-submission-url", authToken, cancelToken, {
        "transaction_id": transactionId,
        "provider_id": providerId,
      });

      if (response.data['success']) {
        return ServerResponse(
            success: true,
            message: response.data['message'],
            data: response.data['data']?['url']);
      } else {
        return ServerResponse(
          success: false,
          message: response.data['message'],
        );
      }
    } catch (e, stackTrace) {
      ErrorInstance(
        message:
            "Error occured when refetching loan agreement form! Contact Support...",
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
          success: false,
          message:
              "Error occured when refetching loan agreement form! Contact Support...");
    }
  }
}
