import 'package:blocsol_loan_application/utils/errors.dart';
import 'package:blocsol_loan_application/utils/http_service.dart';
import 'package:blocsol_loan_application/utils/lender_utils.dart';
import 'package:dio/dio.dart';

class PersonalLoanRequestSearchHttpController {
  final HttpService httpService =
      HttpService(service: ServiceType.PersonalLoan);

  Future<ServerResponse> performGeneralSearch(
      bool foreceNew, String authToken, CancelToken cancelToken) async {
    try {
      var response = await httpService.get("/ondc/general-search", authToken,
          cancelToken, {"force_new": foreceNew ? "y" : "n"});

      if (response.data['success']) {
        String transactionId = response.data['data']?['transaction_id'] ?? "";
        bool redirection = response.data['data']?['alreadyExts'] ?? false;
        String status = response.data['data']?['status'] ?? "search";
        String stateVal = response.data['data']?['state'] ?? "search_00";

        return ServerResponse(
          success: true,
          message: response.data['message'],
          data: {
            "transactionId": transactionId,
            "redirection": redirection,
            "status": status,
            "state": stateVal,
            "offer": response.data['data']?['offer'],
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
          success: false,
          message:
              "service unavailable. Try again later!");
    }
  }

  Future<ServerResponse> provideDataConsent(
      String authToken, CancelToken cancelToken) async {
    try {
      var response = await httpService
          .post("/ondc/provide-data-consent", authToken, cancelToken, {});

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
          success: false,
          message:
              "service unavailable. Try again later!");
    }
  }

  Future<ServerResponse> submitFormsAndGenerateAAURL(
      String selectedEmploymentType,
      String income,
      String endUse,
      AccountAggregatorInfo selectedAA,
      String transactionId,
      String authToken,
      CancelToken cancelToken) async {
    try {
      var response = await httpService
          .post("/ondc/submit-personal-info-forms", authToken, cancelToken, {
        "employment_type": selectedEmploymentType,
        "income": income,
        "end_use": endUse,
        "aa_id": selectedAA.aaId,
        "transaction_id": transactionId,
      });

      if (!response.data['success']) {
        return ServerResponse(
          success: false,
          message: response.data['message'],
        );
      }

      response = await httpService
          .post("/ondc/generate_aa_url", authToken, cancelToken, {
        "aa_name": selectedAA.key,
        "aa_url": selectedAA.url,
        "aa_id": selectedAA.aaId,
        "transaction_id": transactionId,
      });

      if (response.data['success']) {
        return ServerResponse(
          success: true,
          message: response.data['message'],
          data: response.data['data']['aa_url'],
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
          success: false,
          message:
              "service unavailable. Try again later!");
    }
  }

  Future<ServerResponse> checkConsentSuccess(
      String ecres,
      String resdate,
      String transactionId,
      String aaKey,
      String authToken,
      CancelToken cancelToken) async {
    try {
      var response = await httpService
          .post("/ondc/check_aa_consent_success", authToken, cancelToken, {
        "ecres": ecres,
        "resdate": resdate,
        "transaction_id": transactionId,
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
          success: false,
          message:
              "service unavailable. Try again later!");
    }
  }
}
