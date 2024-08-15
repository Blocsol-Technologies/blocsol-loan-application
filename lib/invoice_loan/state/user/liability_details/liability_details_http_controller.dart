import 'package:blocsol_loan_application/utils/errors.dart';
import 'package:blocsol_loan_application/utils/http_service.dart';

import 'package:dio/dio.dart';

class InvoiceLoanLiabilityDetailsHttpController {
  final httpService = HttpService(service: ServiceType.InvoiceLoan);

  Future<ServerResponse> getLiabilityDetails(
      String authToken, CancelToken cancelToken) async {
    try {
      
      var response = await httpService
          .get("/accounts/get-liability-details", authToken, cancelToken, {});

      if (response.data['success']) {
        return ServerResponse(
            success: true,
            message: response.data['message'],
            data: {
              "totalOutstandingLoans":
                  response.data['data']?['totalOutstandingLoans'] ?? 0.0,
              "totalClosedLoans":
                  response.data['data']?['totalClosedLoans'] ?? 0.0,
              "totalOutstandingValue":
                  response.data['data']?['totalOutstandingValue'] ?? 0.0,
              "totalClosedValue":
                  response.data['data']?['totalClosedValue'] ?? 0.0,
            });
      } else {
        return ServerResponse(
            success: false, message: response.data['message']);
      }
    } catch (e, stackTrace) {
      ErrorInstance(
        message: "error occured when getting company liability details!",
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
              "Error occured when getting company liability details! Contact Support...");
    }
  }
}
