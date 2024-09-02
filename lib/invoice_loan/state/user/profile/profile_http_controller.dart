import 'package:blocsol_loan_application/invoice_loan/state/user/profile/state/bank_account.dart';
import 'package:blocsol_loan_application/invoice_loan/state/user/profile/state/notification.dart';
import 'package:blocsol_loan_application/utils/errors.dart';
import 'package:blocsol_loan_application/utils/http_service.dart';

import 'package:dio/dio.dart';

class InvoiceLoanUserProfileDetailsHttpController {
  final httpService = HttpService(service: ServiceType.InvoiceLoan);

  Future<ServerResponse> getCompanyDetails(
      String authToken, CancelToken cancelToken) async {
    try {
      var response = await httpService
          .get("/accounts/get-msme-basic-details", authToken, cancelToken, {});

      if (response.data['success']) {
        List<IbcNotification> notifications = [];

        if (response.data['data']['notifications'] != null) {
          List<dynamic> notificationsData =
              response.data['data']['notifications'];

          notifications = notificationsData
              .map((item) => IbcNotification.fromJson(item))
              .toList();
        }

        List<BankAccountDetails> bankAccountsList = [];

        List<dynamic> bankAccounts = response.data['data']['bankAccounts'];

        bankAccountsList = bankAccounts
            .map((item) => BankAccountDetails.fromJson(item))
            .toList();

        BankAccountDetails primaryBankAccount = BankAccountDetails.fromJson(
            response.data['data']['primaryBankAccount']);

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
              "dataConsentProvided":
                  response.data['data']?['dataConsentProvided'] ?? false,
              "accountAggregatorSetup":
                  response.data['data']?['accountAggregatorSetup'] ?? false,
              "bankAccounts": bankAccountsList,
              "primaryBankAccount": primaryBankAccount,
              "accountAggregatorId": response.data['data']
                  ?['accountAggregatorId'] ?? "",
                  "notifications": notifications,
                  "notificationsSeen": response.data['data']['notificationsSeen'],
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

  Future<ServerResponse> updateBankAccountDetails(
      String accountNumber,
      String ifscCode,
      bool setPrimary,
      String authToken,
      CancelToken cancelToken) async {
    try {
      var response = await httpService.post(
          "/accounts/update-bank-account-details", authToken, cancelToken, {
        "accountNumber": accountNumber,
        "ifscCode": ifscCode,
        "setPrimary": setPrimary,
      });

      if (response.data['success']) {
        return ServerResponse(
            success: true, message: "bank account details updated");
      } else {
        return ServerResponse(
            success: false, message: response.data['message']);
      }
    } catch (e, stackTrace) {
      ErrorInstance(
        message: "error occured when updating bank account details!",
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
              "Error occured when updating bank account details! Contact Support...");
    }
  }

  Future<ServerResponse> updateAccountAggregator(String accountAggregatorName,
      String authToken, CancelToken cancelToken) async {
    try {
      var response = await httpService
          .post("/accounts/update-account-aggregator", authToken, cancelToken, {
        "accountAggregator": accountAggregatorName,
      });

      if (response.data['success']) {
        return ServerResponse(
            success: true, message: "account aggregator details updated");
      } else {
        return ServerResponse(
            success: false, message: response.data['message']);
      }
    } catch (e, stackTrace) {
      ErrorInstance(
        message: "error occured when updating account aggregator details!",
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
              "Error occured when updating account aggregator details! Contact Support...");
    }
  }

  Future<ServerResponse> changeAccountPassword(String oldPassword,
      String newPassoword, String authToken, CancelToken cancelToken) async {
    try {
      var response = await httpService
          .post("/accounts/change-account-password", authToken, cancelToken, {
        "oldPassword": oldPassword,
        "newPassword": newPassoword,
      });

      if (response.data['success']) {
        return ServerResponse(
            success: true, message: "account password details updated");
      } else {
        return ServerResponse(
            success: false, message: response.data['message']);
      }
    } catch (e, stackTrace) {
      ErrorInstance(
        message: "error occured when updating account password details!",
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
              "Error occured when updating account password details! Contact Support...");
    }
  }

  Future<ServerResponse> markNotificationsRead(
      String deviceId, String authToken, CancelToken cancelToken) async {
    try {
      var response = await httpService
          .post("/accounts/mark-notifications-read", authToken, cancelToken, {
        "device_id": deviceId,
      });

      if (response.data['success']) {
        return ServerResponse(
            success: true, message: "notifications marked as read");
      } else {
        return ServerResponse(
            success: false, message: response.data['message']);
      }
    } catch (e, stackTrace) {
      ErrorInstance(
        message: "error occured when marking notifications as read!",
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
              "Error occured when marking notifications as read! Contact Support...");
    }
  }
}
