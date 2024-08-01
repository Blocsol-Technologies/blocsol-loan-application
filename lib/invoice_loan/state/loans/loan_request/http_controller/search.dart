
import 'package:blocsol_loan_application/invoice_loan/state/loans/loan_details.dart';
import 'package:blocsol_loan_application/utils/errors.dart';
import 'package:blocsol_loan_application/utils/http_service.dart';
import 'package:dio/dio.dart';

class LoanRequestSearchHttpController {
  static Future<ServerResponse> performGeneralSearch(
      bool foreceNew, String authToken, CancelToken cancelToken) async {
    try {
      var httpService = HttpService();
      var response = await httpService.get("/ondc/general-search", authToken,
          cancelToken, {"force_new": foreceNew ? "y" : "n"});

      // var response = await httpService.get(
      //     "/ondc/general-search", authToken, cancelToken, {"force_new": "y"});

      if (response.data['success']) {
        bool redirection = response.data['data']?['alreadyExts'] ?? false;
        String status = response.data['data']?['status'] ?? "search";
        String stateVal = response.data['data']?['state'] ?? "search_00";
        var invoiceWithOffer = LoanDetails.demo();

        // This will only be true if redirection is true

        if (redirection) {
          if (status == "search") {
            return ServerResponse(
                success: true,
                message: response.data['message'],
                data: {
                  "invoiceWithOffer": invoiceWithOffer,
                  "transactionId":
                      response.data['data']?['transaction_id'] ?? "",
                  'redirection': redirection,
                  'status': status,
                  'state': stateVal,
                });
          }

          invoiceWithOffer =
              LoanDetails.fromJson(response.data['data']?['invoiceWithOffer']);

          return ServerResponse(
              success: true,
              message: response.data['message'],
              data: {
                "invoiceWithOffer": invoiceWithOffer,
                "transactionId": response.data['data']?['transaction_id'] ?? "",
                'redirection': redirection,
                'status': status,
                'state': stateVal,
              });
        }

        return ServerResponse(
            success: true,
            message: response.data['message'],
            data: {
              "invoiceWithOffer": invoiceWithOffer,
              "transactionId": response.data['data']?['transaction_id'] ?? "",
              'redirection': false,
              'status': status,
              'state': stateVal,
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
            "Error occured when performing general search! Contact Support...",
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
              "Error occured when performing general search! Contact Support...");
    }
  }

  static Future<ServerResponse> submitForms(
      String transactionId, String authToken, CancelToken cancelToken) async {
    try {
      var httpService = HttpService();
      var response =
          await httpService.post("/ondc/submit-forms", authToken, cancelToken, {
        "transaction_id": transactionId,
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
        message: "Error occured when submitting forms! Contact Support...",
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
          message: "Error occured when submitting forms! Contact Support...");
    }
  }

  static Future<ServerResponse> generateAAUrl(
      String transactionId,
      String aaId,
      String aaUrl,
      String key,
      String authToken,
      CancelToken cancelToken) async {
    try {
      var httpService = HttpService();
      var response = await httpService
          .post("/ondc/generate_aa_url", authToken, cancelToken, {
        "transaction_id": transactionId,
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
              "redirect": response.data['data']?['redirect'] ?? false,
            });
      } else {
        return ServerResponse(
          success: false,
          message: response.data['message'],
        );
      }
    } catch (e, stackTrace) {
      ErrorInstance(
        message: "Error occured when generating AA URL! Contact Support...",
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
          message: "Error occured when generating AA URL! Contact Support...");
    }
  }

  static Future<ServerResponse> checkConsentSuccess(
      String transactionId,
      String ecres,
      String resdate,
      String key,
      String authToken,
      CancelToken cancelToken) async {
    try {
      var httpService = HttpService();
      var response = await httpService
          .post("/ondc/check_aa_consent_success", authToken, cancelToken, {
        "transaction_id": transactionId,
        "ecres": ecres,
        "resdate": resdate,
        "aa_name": key,
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
            "Error occured when checking consent success! Contact Support...",
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
              "Error occured when checking consent success! Contact Support...");
    }
  }

  static Future<ServerResponse> fetchLoanOffers(
      String transactionId, String authToken, CancelToken cancelToken) async {
    try {
      var httpService = HttpService();

      var response = await httpService
          .get("/ondc/fetch-invoice-offers", authToken, cancelToken, {
        "transaction_id": transactionId,
      });

      if (response.data['success']) {
        List<LoanDetails> formattedInvoiceWithOffers;

        List<dynamic> invoicesWithOffers =
            response.data['data']?['invoicesWithOffers'] ?? [];

        formattedInvoiceWithOffers = invoicesWithOffers
            .map((item) => LoanDetails.fromJson(item))
            .toList();

        return ServerResponse(
            success: true,
            message: response.data['message'],
            data: formattedInvoiceWithOffers);
      } else {
        return ServerResponse(
          success: false,
          message: response.data['message'],
        );
      }
    } catch (e, stackTrace) {
      ErrorInstance(
        message: "Error occured when fetching loan offers! Contact Support...",
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
              "Error occured when fetching loan offers! Contact Support...");
    }
  }
}
