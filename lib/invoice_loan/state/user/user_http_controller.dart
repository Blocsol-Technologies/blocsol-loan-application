
import 'package:blocsol_loan_application/utils/errors.dart';
import 'package:blocsol_loan_application/utils/http_service.dart';

import 'package:dio/dio.dart';

class UserDetailsHttpController {
  static Future<ServerResponse> getCompanyDetails(
      String authToken, CancelToken cancelToken) async {
    try {
      var httpService = HttpService();
      var response = await httpService
          .get("/accounts/get-msme-basic-details", authToken, cancelToken, {});

      if (response.data['success']) {
        return ServerResponse(
            success: true,
            message: response.data['message'],
            data: {
              "gstNumber": response.data['data']?['gstNumber'] ?? "",
              "gstUsername": response.data['data']?['gstUsername'] ?? "",
              "email": response.data['data']?['email'] ?? "",
              "phone": response.data['data']?['phone'] ?? "",
              "businessLocation":
                  response.data['data']?['businessLocation'] ?? "",
              "legalName": response.data['data']?['legalName'] ?? "",
              "tradeName": response.data['data']?['tradeName'] ?? "",
              "udyamNumber": response.data['data']?['udyamNumber'] ?? "",
            });
      } else {
        return ServerResponse(
            success: false, message: response.data['message']);
      }
    } catch (e, stackTrace) {
      ErrorInstance(
        message: "error occured when getting company details!",
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
              "Error occured when getting company details! Contact Support...");
    }
  }
}
