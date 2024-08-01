
import 'package:blocsol_loan_application/utils/errors.dart';
import 'package:blocsol_loan_application/utils/http_service.dart';
import 'package:dio/dio.dart';

class LoanRequestConfirmHttpController {
  static Future<ServerResponse> checkMonitoringConsentRequirement(
      String transactionId,
      String providerId,
      String authToken,
      CancelToken cancelToken) async {
    try {
      var httpService = HttpService();

      var response = await httpService.post(
          "/ondc/check-monitoring-consent-requirement",
          authToken,
          cancelToken, {
        "transaction_id": transactionId,
        "provider_id": providerId,
      });

      if (response.data['success']) {
        return ServerResponse(
            success: true,
            message: response.data['message'],
            data: {
              "monitoring_consent_required": response.data['data']
                      ?['monitoring_consent_required'] ??
                  false,
              "loan_sanctioned":
                  response.data['data']?['loan_sanctioned'] ?? false,
              "loan_sanctioned_error":
                  response.data['data']?['loan_sanctioned_error'] ?? "",
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
            "Error occured when checking monitoring consent requirement! Contact Support...",
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
              "Error occured when checking monitoring consent requirement! Contact Support...");
    }
  }

  static Future<ServerResponse> generateMonitoringConsentUrl(
      String aaId,
      String aaUrl,
      String key,
      String transactionId,
      String providerId,
      String authToken,
      CancelToken cancelToken) async {
    try {
      var httpService = HttpService();
      var response = await httpService.post(
          "/ondc/generate-loan-monitoring-consent-handler",
          authToken,
          cancelToken, {
        "transaction_id": transactionId,
        "provider_id": providerId,
        "aa_id": aaId,
        "aa_url": aaUrl,
        "aa_name": key,
      });

      if (response.data['success']) {
        return ServerResponse(
            success: true,
            message: response.data['message'],
            data: {
              "url": response.data['data']?['aa_url'] ?? "",
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
            "Error occured when generating monitoring consent URL! Contact Support...",
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
              "Error occured when generating monitoring consent URL! Contact Support...");
    }
  }

  static Future<ServerResponse> checkMonitoringConsentSuccess(
      String ecres,
      String resdate,
      String aaName,
      String transactionId,
      String providerId,
      String authToken,
      CancelToken cancelToken) async {
    try {
      var httpService = HttpService();
      var response = await httpService.post(
          "/ondc/check-loan-monitoring-consent-success",
          authToken,
          cancelToken, {
        "transaction_id": transactionId,
        'provider_id': providerId,
        "ecres": ecres,
        "resdate": resdate,
        "aa_name": aaName,
      });

      if (response.data['success']) {
        return ServerResponse(
            success: true,
            message: response.data['message'],
            data: response.data['data']?['loan_id'] ?? "");
      } else {
        return ServerResponse(
          success: false,
          message: response.data['message'],
        );
      }
    } catch (e, stackTrace) {
      ErrorInstance(
        message:
            "Error occured when checking monitoring consent success! Contact Support...",
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
              "Error occured when checking monitoring consent success! Contact Support...");
    }
  }

  static Future<ServerResponse> checkLoanDisbursementSuccess(
      String transactionId,
      String providerId,
      String authToken,
      CancelToken cancelToken) async {
    try {
      var httpService = HttpService();
      var response = await httpService
          .post("/ondc/check-disbursement-success", authToken, cancelToken, {
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
            "Error occured when checking loan disbursement success! Contact Support...",
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
              "Error occured when checking loan disbursement success! Contact Support...");
    }
  }
}
