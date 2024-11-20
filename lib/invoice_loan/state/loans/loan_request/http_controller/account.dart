import 'package:blocsol_loan_application/invoice_loan/state/loans/loan_details.dart';
import 'package:blocsol_loan_application/utils/errors.dart';
import 'package:blocsol_loan_application/utils/http_service.dart';
import 'package:dio/dio.dart';

class LoanRequestAccountHttpController {
  final httpService = HttpService(service: ServiceType.InvoiceLoan);

  Future<ServerResponse> provideGstConsent(
      String authToken, CancelToken cancelToken) async {
    try {
      var response = await httpService
          .post("/ondc/provide-gst-consent", authToken, cancelToken, {});

      if (response.data['success']) {
        return ServerResponse(
            success: true,
            message: response.data['message'],
            data: {
              "gstDataDownloadTime":
                  response.data['data']?['dataDownloadTime'] ?? "",
              "validationRequired":
                  response.data['data']?['validationRequired'] ?? false
            });
      } else {
        return ServerResponse(
          success: false,
          message: response.data['message'],
        );
      }
    } catch (e, stackTrace) {
      ErrorInstance(
        message: "Error occured when providing GST Consent! Contact Support...",
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

  Future<ServerResponse> sendGstOtp(
      String authToken, CancelToken cancelToken) async {
    try {
      var response = await httpService
          .get("/ondc/send-gst-otp", authToken, cancelToken, {});

      if (response.data['success']) {
        return ServerResponse(
            success: true,
            message: response.data['message'],
            data: {
              "validationRequired":
                  response.data['data']?['validationRequired'] ?? false
            });
      } else {
        return ServerResponse(
            success: false,
            message: response.data['message'],
            data: {
              "validationRequired":
                  response.data['data']?['validationRequired'] ?? false
            });
      }
    } catch (e, stackTrace) {
      ErrorInstance(
        message: "Error occured when sending GST OTP! Contact Support...",
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
          message: "Error occured when sending GST OTP! Contact Support...");
    }
  }

  Future<ServerResponse> verifyGstOtp(
      String otp, String authToken, CancelToken cancelToken) async {
    try {
      var response = await httpService
          .post("/ondc/verify-gst-otp", authToken, cancelToken, {"otp": otp});

      if (response.data['success']) {
        return ServerResponse(
            success: true,
            message: response.data['message'],
            data: response.data['data']?['dataDownloadTime'] ?? "");
      } else {
        return ServerResponse(
          success: false,
          message: response.data['message'],
        );
      }
    } catch (e, stackTrace) {
      ErrorInstance(
        message: "Error occured when verifying GST OTP! Contact Support...",
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
          message: "Error occured when verifying GST OTP! Contact Support...");
    }
  }

  Future<ServerResponse> downloadGstData(
      String authToken, CancelToken cancelToken) async {
    try {
      var response = await httpService
          .post("/ondc/download-gst-data", authToken, cancelToken, {});

      if (response.data['success']) {
        return ServerResponse(
            success: true,
            message: response.data['message'],
            data: response.data['data']?['dataDownloadTime'] ?? "");
      } else {
        return ServerResponse(
          success: false,
          message: response.data['message'],
        );
      }
    } catch (e, stackTrace) {
      ErrorInstance(
        message: "Error occured when downloading GST Data! Contact Support...",
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
              "Error occured when downloading GST Data! Contact Support...");
    }
  }

  Future<ServerResponse> fetchGstInvoices(
      String authToken, CancelToken cancelToken) async {
    try {
      var response = await httpService
          .get("/ondc/fetch-gst-invoices", authToken, cancelToken, {});

      if (response.data['success']) {
        List<Invoice> formattedInvoices;

        try {
          List<dynamic> invoices = response.data['data']?['invoiceList'] ?? [];
          formattedInvoices =
              invoices.map((item) => Invoice.fromJson(item)).toList();
        } catch (err) {
          formattedInvoices = [];
        }

        return ServerResponse(
            success: true,
            message: response.data['message'],
            data: {
              "formattedInvoices": formattedInvoices,
              "refetchData": response.data['data']?['refetchData'] ?? false
            });
      } else {
        return ServerResponse(
          success: false,
          message: response.data['message'],
        );
      }
    } catch (e, stackTrace) {
      ErrorInstance(
        message: "Error occured when fetching GST Invoices! Contact Support...",
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
              "Error occured when fetching GST Invoices! Contact Support...");
    }
  }
}
