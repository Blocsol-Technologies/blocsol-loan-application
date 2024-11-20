import 'package:blocsol_loan_application/personal_loan/state/user/utils/loan/loan_details.dart';
import 'package:blocsol_loan_application/utils/errors.dart';
import 'package:blocsol_loan_application/utils/http_service.dart';
import 'package:dio/dio.dart';

class PersonalLoanRequestSelectHttpController {
  final HttpService httpService =
      HttpService(service: ServiceType.PersonalLoan);

  Future<ServerResponse> fetchOffers(
      String transactionId, String authToken, CancelToken cancelToken) async {
    try {
      var response = await httpService.post("/ondc/fetch-offers", authToken,
          cancelToken, {"transaction_id": transactionId});

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
              "service unavailable. Try again later!");
    }
  }

  Future<ServerResponse> performSelect2(String transactionId, String providerId,
      String authToken, CancelToken cancelToken) async {
    try {
      var response = await httpService
          .post("/ondc/perform-select-02", authToken, cancelToken, {
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

  Future<ServerResponse> performNextActionsAfterOfferSelection(
      String transactionId,
      String providerId,
      String authToken,
      CancelToken cancelToken) async {
    try {
      var response = await httpService.post(
          "/ondc/perform-next-steps-after-offer-selection",
          authToken,
          cancelToken, {
        "transaction_id": transactionId,
        "provider_id": providerId,
      });

      if (response.data['success']) {
        return ServerResponse(
            success: true,
            message: response.data['message'],
            data: {
              "navigateToAadharKYC":
                  response.data['data']?['navigateToAadharKYC'] ?? false
            });
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

  Future<ServerResponse> submitLoanOfferChangeForm(
      String requestedAmount,
      String transactionId,
      String providerId,
      String authToken,
      CancelToken cancelToken) async {
    try {
      var response = await httpService
          .post("/ondc/submit-form-02", authToken, cancelToken, {
        "transaction_id": transactionId,
        "provider_id": providerId,
        "requested_loan_amount": requestedAmount,
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

  Future<ServerResponse> fetchUpdatedLoanOffer(
      String offerId,
      String transactionId,
      String providerId,
      String authToken,
      CancelToken cancelToken) async {
    try {
      var response = await httpService.post(
          "/ondc/fetch-updated-offer", authToken, cancelToken, {
        "transaction_id": transactionId,
        "provider_id": providerId,
        "offer_id": offerId
      });

      if (response.data['success']) {
        PersonalLoanDetails offerDetails = PersonalLoanDetails.fromJson(
            response.data['data']?['offer_details']);
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
