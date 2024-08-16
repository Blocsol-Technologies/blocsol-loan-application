import 'package:blocsol_loan_application/personal_loan/state/user/support/state/support_state.dart';
import 'package:blocsol_loan_application/utils/errors.dart';
import 'package:blocsol_loan_application/utils/http_service.dart';
import 'package:dio/dio.dart';

class PersonalLoanSupportHttpController {
  final HttpService httpService =
      HttpService(service: ServiceType.PersonalLoan);

  Future<ServerResponse> fetchAllSupportTickets(
      String authToken, CancelToken cancelToken) async {
    try {
      var response = await httpService
          .get("/ondc/get-all-support-tickets", authToken, cancelToken, {});

      if (response.data['success']) {
        List<SupportTicket> formatedSupportTickets = [];

        List<dynamic> supportTickets =
            response.data['data']?['support_tickets'] ?? [];

        formatedSupportTickets =
            supportTickets.map((item) => SupportTicket.fromJson(item)).toList();

        return ServerResponse(
          success: true,
          message: response.data['message'],
          data: formatedSupportTickets,
        );
      } else {
        return ServerResponse(
            success: false, message: response.data['message']);
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
              "error occured when validating password! Contact Support...");
    }
  }

  Future<ServerResponse> fetchSingleSupportTicket(
      String transactionId,
      String providerId,
      String issueId,
      String authToken,
      CancelToken cancelToken) async {
    try {
      var response = await httpService.post(
          "/ondc/get-single-support-ticket-details", authToken, cancelToken, {
        'transaction_id': transactionId,
        'provider_id': providerId,
        'issue_id': issueId,
      });

      if (response.data['success']) {
        var supportTicket =
            SupportTicket.fromJson(response.data['data']['support_ticket']);

        return ServerResponse(
          success: true,
          message: response.data['message'],
          data: supportTicket,
        );
      } else {
        return ServerResponse(
            success: false, message: response.data['message']);
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
              "error occured when validating password! Contact Support...");
    }
  }

  Future<ServerResponse> raiseSupportIssue(
      String category,
      String subCategory,
      String status,
      String message,
      List<String> images,
      String transactionId,
      String providerId,
      String authToken,
      CancelToken cancelToken) async {
    try {
      var response = await httpService
          .post("/ondc/generate-support-ticket", authToken, cancelToken, {
        'transaction_id': transactionId,
        'provider_id': providerId,
        'category': category,
        'sub_category': subCategory,
        'status': status,
        'message': message,
        'images': images,
      });

      if (response.data['success']) {
        return ServerResponse(
          success: true,
          message: response.data['message'],
        );
      } else {
        return ServerResponse(
            success: false, message: response.data['message']);
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
              "error occured when validating password! Contact Support...");
    }
  }

  Future<ServerResponse> sendStatusRequest(String issueId, String transactionId,
      String providerId, String authToken, CancelToken cancelToken) async {
    try {
      var response = await httpService
          .post("/ondc/raise-issue-status-request", authToken, cancelToken, {
        'transaction_id': transactionId,
        'provider_id': providerId,
        'issue_id': issueId,
      });

      if (response.data['success']) {
        return ServerResponse(
          success: true,
          message: response.data['message'],
        );
      } else {
        return ServerResponse(
            success: false, message: response.data['message']);
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
              "error occured when validating password! Contact Support...");
    }
  }
}
