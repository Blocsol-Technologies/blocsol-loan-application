

import 'package:blocsol_loan_application/invoice_loan/state/support/state/support_ticket.dart';
import 'package:blocsol_loan_application/utils/errors.dart';
import 'package:blocsol_loan_application/utils/http_service.dart';
import 'package:dio/dio.dart';

class SupportHttpController {
  static Future<ServerResponse> fetchAllSupportTickets(
      String authToken, CancelToken cancelToken) async {
    try {
      var httpService = HttpService();

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
            data: formatedSupportTickets);
      } else {
        return ServerResponse(
          success: false,
          message: response.data['message'],
        );
      }
    } catch (e, stackTrace) {
      ErrorInstance(
        message:
            "Error occured when fetching all support tickets! Contact Support...",
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
            "Error occured when fetching all support tickets! Contact Support...",
      );
    }
  }

  static Future<ServerResponse> fetchSingleSupportTicketDetails(
      String issueId,
      String transactionId,
      String providerId,
      String authToken,
      CancelToken cancelToken) async {
    try {
      var httpService = HttpService();
      var response = await httpService.post(
          "/ondc/get-single-support-ticket-details", authToken, cancelToken, {
        'transaction_id': transactionId,
        'provider_id': providerId,
        'issue_id': issueId,
      });

      if (response.data['success']) {
        var _ = await httpService
            .post("/ondc/raise-issue-status-request", authToken, cancelToken, {
          'transaction_id': transactionId,
          'provider_id': providerId,
          'issue_id': issueId,
        });

        try {
          var supportTicket =
              SupportTicket.fromJson(response.data['data']['support_ticket']);

          return ServerResponse(
              success: true,
              message: response.data['message'],
              data: supportTicket);
        } catch (err, stackTrace) {
          var errorInstance = ErrorInstance(
            message: "_",
            exception: err,
            trace: stackTrace,
          );

          errorInstance.reportError();
          return ServerResponse(
            success: false,
            message: response.data['message'],
          );
        }
      } else {
        return ServerResponse(
          success: false,
          message: response.data['message'],
        );
      }
    } catch (e, stackTrace) {
      ErrorInstance(
        message:
            "Error occured when fetching single support ticket details! Contact Support...",
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
            "Error occured when fetching single support ticket details! Contact Support...",
      );
    }
  }

  static Future<ServerResponse> raiseSupportIssue(
      String message,
      String status,
      String category,
      String subCategory,
      String transactionId,
      String providerId,
      List<String> images,
      String authToken,
      CancelToken cancelToken) async {
    try {
      var httpService = HttpService();

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
          success: false,
          message: response.data['message'],
        );
      }
    } catch (e, stackTrace) {
      ErrorInstance(
        message: "Error occured when raising support issue! Contact Support...",
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
        message: "Error occured when raising support issue! Contact Support...",
      );
    }
  }

  static Future<ServerResponse> askForStatusUpdate(
      String issueId,
      String transactionId,
      String providerId,
      String authToken,
      CancelToken cancelToken) async {
    try {
      var httpService = HttpService();

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
          success: false,
          message: response.data['message'],
        );
      }
    } catch (e, stackTrace) {
      ErrorInstance(
        message:
            "Error occured when asking for status update! Contact Support...",
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
            "Error occured when asking for status update! Contact Support...",
      );
    }
  }
}
