import 'package:blocsol_loan_application/utils/errors.dart';
import 'package:blocsol_loan_application/utils/http_service.dart';
import 'package:dio/dio.dart';

class PersonalLoanRequestConfirmHttpController {
  final httpService = HttpService(service: ServiceType.PersonalLoan);

  Future<ServerResponse> checkMonitoringConsentRequirement(String transactionId,
      String providerId, String authToken, CancelToken cancelToken) async {
    try {
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

  Future<ServerResponse> fetchLoanMonitoringAAURL(
      String aaId,
      String aaUrl,
      String aaKey,
      String transactionId,
      String providerId,
      String authToken,
      CancelToken cancelToken) async {
    try {
      var response = await httpService.post(
          "/ondc/generate-loan-monitoring-consent-url",
          authToken,
          cancelToken, {
        "transaction_id": transactionId,
        "provider_id": providerId,
        "aa_id": aaId,
        "aa_url": aaUrl,
        "aa_name": aaKey,
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

  Future<ServerResponse> checkLoanMonitoringConsentSuccess(
      String ecres,
      String resdate,
      String aaKey,
      String transactionId,
      String providerId,
      String authToken,
      CancelToken cancelToken) async {
    try {
      var response = await httpService
          .post("/ondc/check-loan-monitoring-success", authToken, cancelToken, {
        "ecres": ecres,
        "resdate": resdate,
        "transaction_id": transactionId,
        "provider_id": providerId,
        "aa_name": aaKey
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
}
