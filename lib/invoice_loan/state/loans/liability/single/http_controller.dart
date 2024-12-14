import 'package:blocsol_loan_application/invoice_loan/state/loans/loan_details.dart';
import 'package:blocsol_loan_application/utils/errors.dart';
import 'package:blocsol_loan_application/utils/http_service.dart';
import 'package:dio/dio.dart';

class LiabilitiesHttpController {
  final httpService = HttpService(service: ServiceType.InvoiceLoan);

  Future<ServerResponse> fetchSingleLiabilityDetails(String transactionId,
      String providerId, String authToken, CancelToken cancelToken) async {
    try {
      var response = await httpService
          .post("/ondc/fetch-single-confirmed-order", authToken, cancelToken, {
        "provider_id": providerId,
        "transaction_id": transactionId,
      });

      if (response.data['success']) {
        final invoiceWithOffer =
            LoanDetails.fromJson(response.data['data']['details']);

        return ServerResponse(
            success: true,
            message: response.data['message'],
            data: invoiceWithOffer);
      } else {
        return ServerResponse(
            success: false, message: response.data['message']);
      }
    } catch (e, stackTrace) {
      ErrorInstance(
        message:
            "Error occured when fetching single liability details! Contact Support...",
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
              "Error occured when fetching single liability details! Contact Support...");
    }
  }

  Future<ServerResponse> performStatusRequest(String transactionId,
      String providerId, String authToken, CancelToken cancelToken) async {
    try {
      var response = await httpService
          .post("/ondc/perform-status-check", authToken, cancelToken, {
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
            "Error occured when performing status request! Contact Support...",
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
              "Error occured when performing status request! Contact Support...");
    }
  }

  Future<ServerResponse> initiateForeclosure(String transactionId,
      String providerId, String authToken, CancelToken cancelToken) async {
    try {
      var response = await httpService
          .post("/ondc/initiate-foreclosure", authToken, cancelToken, {
        "transaction_id": transactionId,
        "provider_id": providerId,
      });

      if (!response.data['success']) {
        return ServerResponse(
          success: false,
          message: response.data['message'],
        );
      }

      await Future.delayed(const Duration(seconds: 10));

      response = await httpService
          .post("/ondc/fetch-foreclosure-url", authToken, cancelToken, {
        "transaction_id": transactionId,
        "provider_id": providerId,
      });

      if (response.data['success']) {
        return ServerResponse(
            success: true,
            message: response.data['message'],
            data: {
              "url": response.data['data']['foreclose_url'],
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
            "Error occured when initiating foreclosure! Contact Support...",
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
              "Error occured when initiating foreclosure! Contact Support...");
    }
  }

  Future<ServerResponse> checkForeclosureSuccess(String transactionId,
      String providerId, String authToken, CancelToken cancelToken) async {
    try {
      var response = await httpService
          .post("/ondc/check-foreclosure-success", authToken, cancelToken, {
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
            "Error occured when checking foreclosure success! Contact Support...",
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
              "Error occured when checking foreclosure success! Contact Support...");
    }
  }

  Future<ServerResponse> initiatePartPrepayment(
      String amount,
      String transactionId,
      String providerId,
      String authToken,
      CancelToken cancelToken) async {
    try {
      var response = await httpService
          .post("/ondc/initiate-prepayment", authToken, cancelToken, {
        "transaction_id": transactionId,
        "provider_id": providerId,
        "amount": amount,
      });

      if (!response.data['success']) {
        return ServerResponse(
          success: false,
          message: response.data['message'],
        );
      }

      await Future.delayed(const Duration(seconds: 10));

      response = await httpService
          .post("/ondc/fetch-prepayment-url", authToken, cancelToken, {
        "transaction_id": transactionId,
        "provider_id": providerId,
      });

      if (response.data['success']) {
        return ServerResponse(
            success: true,
            message: response.data['message'],
            data: {
              "id": response.data['data']['pre_payment_id'],
              "url": response.data['data']['pre_payment_url'],
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
            "Error occured when initiating part prepayment! Contact Support...",
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
              "Error occured when initiating part prepayment! Contact Support...");
    }
  }

  Future<ServerResponse> checkPrepaymentSuccess(
      String prepaymentId,
      String transactionId,
      String providerId,
      String authToken,
      CancelToken cancelToken) async {
    try {
      var response = await httpService
          .post("/ondc/check-prepayment-success", authToken, cancelToken, {
        "transaction_id": transactionId,
        "provider_id": providerId,
        "prepayment_id": prepaymentId,
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
            "Error occured when checking prepayment success! Contact Support...",
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
              "Error occured when checking prepayment success! Contact Support...");
    }
  }

  Future<ServerResponse> initiateMissedEmiRepayment(
      String missedEmiId,
      String transactionId,
      String providerId,
      String authToken,
      CancelToken cancelToken) async {
    try {
      var response = await httpService
          .post("/ondc/initiate-missed-emi-repayment", authToken, cancelToken, {
        "transaction_id": transactionId,
        "provider_id": providerId,
      });

      if (!response.data['success']) {
        return ServerResponse(
          success: false,
          message: response.data['message'],
        );
      }

      await Future.delayed(const Duration(seconds: 10));

      response = await httpService.post(
          "/ondc/fetch-missed-emi-repayment-url", authToken, cancelToken, {
        "transaction_id": transactionId,
        "provider_id": providerId,
        "payment_id": missedEmiId,
      });

      if (response.data['success']) {
        return ServerResponse(
            success: true,
            message: response.data['message'],
            data: {
              "id": response.data['data']['missed_emi_id'],
              "url": response.data['data']['missed_emi_url'],
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
            "Error occured when initiating missed EMI repayment! Contact Support...",
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
              "Error occured when initiating missed EMI repayment! Contact Support...");
    }
  }

  Future<ServerResponse> checkMissedEmiRepaymentSuccess(
      String missedEmiPaymentId,
      String transactionId,
      String providerId,
      String authToken,
      CancelToken cancelToken) async {
    try {
      var response = await httpService.post(
          "/ondc/check-missed-emi-repayment-success", authToken, cancelToken, {
        "transaction_id": transactionId,
        "provider_id": providerId,
        "payment_id": missedEmiPaymentId,
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
            "Error occured when checking missed EMI repayment success! Contact Support...",
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
              "Error occured when checking missed EMI repayment success! Contact Support...");
    }
  }
}
