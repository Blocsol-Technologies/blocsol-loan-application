import 'package:blocsol_loan_application/invoice_loan/state/loans/loan_details.dart';
import 'package:blocsol_loan_application/utils/errors.dart';
import 'package:blocsol_loan_application/utils/http_service.dart';
import 'package:dio/dio.dart';

class LoanRequestSelectHttpController {
  static Future<ServerResponse> refetchSelectedOfferDetails(
      String transactionId,
      String offerId,
      String providerId,
      String authToken,
      CancelToken cancelToken) async {
    try {
      var httpService = HttpService();

      var response = await httpService.post(
          "/ondc/refetch-selected-offer-details", authToken, CancelToken(), {
        "transaction_id": transactionId,
        "offer_id": offerId,
        "provider_id": providerId,
      });

      if (response.data['success']) {
        OfferDetails offerDetails = OfferDetails.fromJson(
            response.data['data']['offer_details'], "initiated");

        return ServerResponse(
            success: true,
            message: response.data['message'],
            data: offerDetails);
      } else {
        return ServerResponse(
          success: false,
          message: response.data['message'],
        );
      }
    } catch (e, stackTrace) {
      ErrorInstance(
        message:
            "Error occured when refetching selected offer details! Contact Support...",
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
              "Error occured when refetching selected offer details! Contact Support...");
    }
  }

  static Future<ServerResponse> selectOffer(
      String transactionId,
      String offerId,
      String invoiceId,
      String providerId,
      String authToken,
      CancelToken cancelToken) async {
    try {
      var httpService = HttpService();
      var response =
          await httpService.post("/ondc/select-offer", authToken, cancelToken, {
        "transaction_id": transactionId,
        "offer_id": offerId,
        "invoice_id": invoiceId,
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
        message: "Error occured when selecting offer! Contact Support...",
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
          message: "Error occured when selecting offer! Contact Support...");
    }
  }

  static Future<ServerResponse> submitLoanUpdateForm(
      String transactionId,
      String providerId,
      String loanTerm,
      String loanAmount,
      String authToken,
      CancelToken cancelToken) async {
    try {
      var httpService = HttpService();

      var response =
          await httpService.post("/ondc/fill-form-02", authToken, cancelToken, {
        "requested_loan_amount": loanAmount,
        "requested_loan_term": loanTerm,
        "transaction_id": transactionId,
        "provider_id": providerId,
      });

      if (response.data['success']) {
        return ServerResponse(
            success: true,
            message: response.data['message'],
            data: {
              "multiple-submissions":
                  response.data['data']?['multiple-submissions'] ?? false,
              "navigateToAadharKYC":
                  response.data['data']?['navigateToAadharKYC'] ?? false,
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
            "Error occured when submitting loan update form! Contact Support...",
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
              "Error occured when submitting loan update form! Contact Support...");
    }
  }

  static Future<ServerResponse> fetchAadharKycUrl(String transactionId,
      String providerId, String authToken, CancelToken cancelToken) async {
    try {
      var httpService = HttpService();

      var response = await httpService
          .post("/ondc/fetch-form-03", authToken, cancelToken, {
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
            "Error occured when fetching aadhar kyc form! Contact Support...",
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
              "Error occured when fetching aadhar kyc form! Contact Support...");
    }
  }

  static Future<ServerResponse> refetchAadharKycUrl(String transactionId,
      String providerId, String authToken, CancelToken cancelToken) async {
    try {
      var httpService = HttpService();
      var response = await httpService.post(
          "/ondc/refetch-form-03-submission-url", authToken, cancelToken, {
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
            "Error occured when refetching aadhar kyc form! Contact Support...",
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
              "Error occured when refetching aadhar kyc form! Contact Support...");
    }
  }

  static Future<ServerResponse> checkAadharKycSuccess(String transactionId,
      String providerId, String authToken, CancelToken cancelToken) async {
    try {
      var httpService = HttpService();

      var response = await httpService.post(
          "/ondc/check-form-03-submission-success", authToken, cancelToken, {
        "transaction_id": transactionId,
        "provider_id": providerId,
      });

      if (response.data['success']) {
        return ServerResponse(
          success: true,
          message: response.data['message'],
          data: response.data['data']?['manuallyMove'] ?? false,
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
            "Error occured when checking aadhar kyc success! Contact Support...",
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
              "Error occured when checking aadhar kyc success! Contact Support...");
    }
  }
}
