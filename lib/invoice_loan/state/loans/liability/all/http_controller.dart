import 'package:blocsol_loan_application/invoice_loan/state/loans/loan_details.dart';
import 'package:blocsol_loan_application/utils/errors.dart';
import 'package:blocsol_loan_application/utils/http_service.dart';
import 'package:dio/dio.dart';

class InvoiceLoanAllLiabilitiesHttpController {

  final httpService = HttpService(service: ServiceType.InvoiceLoan);

   Future<ServerResponse> fetchLiabilities(
      String authToken, CancelToken cancelToken) async {
    try {
      
      var response = await httpService
          .get("/ondc/fetch-all-confirmed-orders", authToken, cancelToken, {});

      // Updating the fetch time in order to show no offers fetched message on frontend if no offers or error

      if (response.data['success']) {
        List<LoanDetails> formattedOffers = [];

        List<dynamic> offers =
            response.data['data']?['invoicesWithOffers'] ?? [];

        formattedOffers =
            offers.map((item) => LoanDetails.fromJson(item)).toList();


        return ServerResponse(
            success: true,
            message: response.data['message'],
            data: formattedOffers);
      } else {
        return ServerResponse(
          success: false,
          message: response.data['message'],
        );
      }
    } catch (e, stackTrace) {
      ErrorInstance(
        message: "Error occured when fetching liabilities! Contact Support...",
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
              "Error occured when fetching liabilities! Contact Support...");
    }
  }

   Future<ServerResponse> fetchAllClosedLiabilities(
      String authToken, CancelToken cancelToken) async {
    try {
      
      var response = await httpService
          .get("/ondc/fetch-all-completed-orders", authToken, cancelToken, {});

      // Updating the fetch time in order to show no offers fetched message on frontend if no offers or error

      if (response.data['success']) {
        List<LoanDetails> formattedOffers = [];

        List<dynamic> offers =
            response.data['data']?['completedOffers'] ?? [];

        formattedOffers =
            offers.map((item) => LoanDetails.fromJson(item)).toList();


        return ServerResponse(
            success: true,
            message: response.data['message'],
            data: formattedOffers);
      } else {
        return ServerResponse(
          success: false,
          message: response.data['message'],
        );
      }
    } catch (e, stackTrace) {
      ErrorInstance(
        message: "Error occured when fetching closed liabilities! Contact Support...",
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
              "Error occured when fetching closed liabilities! Contact Support...");
    }
  }
}
