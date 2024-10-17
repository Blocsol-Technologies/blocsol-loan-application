import 'package:blocsol_loan_application/personal_loan/state/user/account_details/state/account_details_state.dart';
import 'package:blocsol_loan_application/personal_loan/state/user/account_details/state/bank_account_details.dart';
import 'package:blocsol_loan_application/personal_loan/state/user/account_details/state/notifications.dart';
import 'package:blocsol_loan_application/utils/errors.dart';
import 'package:blocsol_loan_application/utils/http_service.dart';
import 'package:dio/dio.dart';

class PersonalLoanAccountDetailsHttpController {
  final HttpService httpService =
      HttpService(service: ServiceType.PersonalLoan);

  Future<ServerResponse> getBorrowerDetails(
      String authToken, CancelToken cancelToken) async {
    try {
      var response = await httpService.get(
          "/accounts/get-borrower-basic-details", authToken, cancelToken, {});

      if (response.data['success']) {
        Address address = Address.fromJson(response.data['data']['address']);

        List<PlNotification> notifications = [];

        if (response.data['data']['notifications'] != null) {
          List<dynamic> notificationsData =
              response.data['data']['notifications'];

          notifications = notificationsData
              .map((item) => PlNotification.fromJson(item))
              .toList();
        }

        List<PlBankAccountDetails> bankAccountsList = [];

        List<dynamic> bankAccounts = response.data['data']['bankAccounts'];

        bankAccountsList = bankAccounts
            .map((item) => PlBankAccountDetails.fromJson(item))
            .toList();

        PlBankAccountDetails primaryBankAccount = PlBankAccountDetails.fromJson(
            response.data['data']['primaryBankAccount']);

        return ServerResponse(
          success: true,
          message: response.data['message'],
          data: {
            "name":
                "${response.data['data']['firstName']} ${response.data['data']['lastName']}",
            "imageURL": response.data['data']['profilePicURL'],
            "dob": response.data['data']['dob'],
            "gender": response.data['data']['gender'],
            "pan": response.data['data']['pan'],
            "phone": response.data['data']['phone'],
            "email": response.data['data']['email'],
            "udyamNumber": response.data['data']['udyamNumber'],
            "companyName": response.data['data']['companyName'],
            "address": address,
            "accountAggregatorSetup":
                response.data['data']?['accountAggregatorSetup'] ?? false,
            "bankAccounts": bankAccountsList,
            "primaryBankAccount": primaryBankAccount,
            "accountAggregatorId":
                response.data['data']?['accountAggregatorId'] ?? "",
            "notifications": notifications,
            "notificationsSeen": response.data['data']['notificationsSeen'],
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
          success: false, message: "Service unavailable! Contact Support...");
    }
  }

  Future<ServerResponse> updateBankAccountDetails(
      String accountNumber,
      String ifscCode,
      bool setPrimary,
      int accountType,
      String authToken,
      CancelToken cancelToken) async {
    try {
      var response = await httpService.post(
          "/accounts/update-bank-account-details", authToken, cancelToken, {
        "accountNumber": accountNumber,
        "ifscCode": ifscCode,
        "setPrimary": setPrimary,
        "bankAccountType": accountType,
      });
      

      if (response.data['success']) {
        return ServerResponse(
            success: true,
            message: "bank account details updated",
            data: {
              "bankName": response.data['data']['bankName'],
              "accountNumber": response.data['data']['accountNumber'],
              "ifscCode": response.data['data']['ifscCode'],
              "accountHolderName": response.data['data']['accountHolderName']
            });
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
