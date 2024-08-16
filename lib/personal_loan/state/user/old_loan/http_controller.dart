import 'package:blocsol_loan_application/personal_loan/state/user/utils/loan/loan_details.dart';
import 'package:blocsol_loan_application/utils/errors.dart';
import 'package:blocsol_loan_application/utils/http_service.dart';
import 'package:dio/dio.dart';

class PersonalLoanLiabilitiesHttpController {
  final HttpService httpService =
      HttpService(service: ServiceType.PersonalLoan);

  Future<ServerResponse> fetchOffers(
      String authToken, CancelToken cancelToken) async {
    try {
      var response = await httpService
          .get("/ondc/fetch-all-confirmed-orders", authToken, cancelToken, {});

      if (response.data['success']) {
        List<PersonalLoanDetails> formattedOffers = [];

        List<dynamic> offers = response.data['data']?['offers'] ?? [];

        formattedOffers =
            offers.map((item) => PersonalLoanDetails.fromJson(item)).toList();

        return ServerResponse(
          success: true,
          message: response.data['message'],
          data: formattedOffers,
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

  Future<ServerResponse> refetchSelectedLoanOfferDetails(String transactionId,
      String providerId, String authToken, CancelToken cancelToken) async {
    try {
      var response = await httpService
          .post("/ondc/fetch-single-confirmed-order", authToken, cancelToken, {
        "transaction_id": transactionId,
        "provider_id": providerId,
      });

      if (response.data['success']) {
        PersonalLoanDetails formattedOffer =
            PersonalLoanDetails.fromJson(response.data['data']?['details']);

        return ServerResponse(
          success: true,
          message: response.data['message'],
          data: formattedOffer,
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
            success: false, message: response.data['message']);
      }

      response = await httpService
          .post("/ondc/fetch-foreclosure-url", authToken, cancelToken, {
        "transaction_id": transactionId,
        "provider_id": providerId,
      });

      if (response.data['success']) {
        return ServerResponse(
          success: true,
          message: response.data['message'],
          data: response.data['data']['foreclose_url'],
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
            success: false, message: response.data['message']);
      }

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
            "prepaymentId": response.data['data']['pre_payment_id'],
            "url": response.data['data']['pre_payment_url'],
          },
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

  Future<ServerResponse> initiateMissedEMIPayment(
      String missedEmiPaymentId,
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
            success: false, message: response.data['message']);
      }

      response = await httpService.post(
          "/ondc/fetch-missed-emi-repayment-url", authToken, cancelToken, {
        "transaction_id": transactionId,
        "provider_id": providerId,
        "payment_id": missedEmiPaymentId,
      });

      if (response.data['success']) {
        return ServerResponse(
          success: true,
          message: response.data['message'],
          data: {
            "missedEmiPaymentId": response.data['data']['missed_emi_id'],
            "url": response.data['data']['missed_emi_url'],
          },
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

  Future<ServerResponse> checkMissedEMIRepaymentSuccess(
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
