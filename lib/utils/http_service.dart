import 'dart:convert';

import 'package:blocsol_loan_application/utils/logger.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:dio/dio.dart';

const String invoiceLoanServerUrl =
    "https://ondc.invoicepe.in/financial-services/invoice-based-credit";

const String personalLoanServerUrl =
    "https://f739-2401-4900-1c6e-5c6d-1049-5a06-5387-7877.ngrok-free.app/financial-services/personal-credit";
    
const String invoiceLoanbaseUrl =
    "https://ondc.invoicepe.in/financial-services/invoice-based-credit";

const String personalLoanbaseUrl =
    "https://f739-2401-4900-1c6e-5c6d-1049-5a06-5387-7877.ngrok-free.app/financial-services/personal-credit";

enum ServiceType {
  InvoiceLoan,
  PersonalLoan,
}

class HttpService {
  late Dio _dio;

  HttpService({required ServiceType service}) {
    switch (service) {
      case ServiceType.InvoiceLoan:
        _dio = Dio(BaseOptions(baseUrl: invoiceLoanbaseUrl));
        break;
      case ServiceType.PersonalLoan:
        _dio = Dio(BaseOptions(baseUrl: personalLoanbaseUrl));
        break;
      default:
        throw Exception("Invalid Service Type");
    }
    _dio.options.receiveTimeout = const Duration(minutes: 5);
  }

  Future<Response> get(
    String endpoint,
    String authToken,
    CancelToken cancelToken,
    Map<String, String> queryParams,
  ) async {
    Response response = Response(requestOptions: RequestOptions());
    try {
      logger.d(
          "Sending GET Request to enpoint: $endpoint \n Query Params: $queryParams");

      bool isConnected = await InternetConnection().hasInternetAccess;

      if (!isConnected) {
        throw DioException(
            response: Response(requestOptions: RequestOptions(), data: {
              "success": false,
              "message": "No Internet Connection",
            }),
            requestOptions: RequestOptions());
      }

      response = await _dio.get(
        endpoint,
        options: Options(
          contentType: Headers.jsonContentType,
          headers: {'Authorization': authToken},
        ),
        queryParameters: queryParams,
        cancelToken: CancelToken(),
      );
    } on DioException catch (err, stackTrace) {
      logger.e(
          "Dio error: $endpoint \n STATUS: ${err.response?.statusCode} \n DATA: ${err.response?.data} \n HEADERS: ${err.response?.headers}",
          error: err,
          stackTrace: stackTrace);

      rethrow;
    }

    logger.f(
        "Reponse for the GET Request to enpoint: $endpoint \n Query Params: $queryParams \n STATUS: ${response.statusCode} \n DATA: ${response.data}");
    return response;
  }

  Future<Response> post(
    String endpoint,
    String authToken,
    CancelToken cancelToken,
    Map data,
  ) async {
    Response response = Response(requestOptions: RequestOptions());
    try {
      logger.d(
          "Sending POST Request to enpoint: $endpoint \n Body Params: $data");

      bool isConnected = await InternetConnection().hasInternetAccess;

      if (!isConnected) {
        throw DioException(
            response: Response(requestOptions: RequestOptions(), data: {
              "success": false,
              "message": "No Internet Connection",
            }),
            requestOptions: RequestOptions());
      }

      response = await _dio.post(
        endpoint,
        data: jsonEncode(data),
        options: Options(
          contentType: Headers.jsonContentType,
          headers: {'Authorization': authToken},
        ),
        cancelToken: CancelToken(),
      );
    } on DioException catch (err, stackTrace) {
      logger.e(
          "Dio error: $endpoint \n STATUS: ${err.response?.statusCode} \n DATA: ${err.response?.data} \n HEADERS: ${err.response?.headers}",
          error: err,
          stackTrace: stackTrace);

      rethrow;
    }

    logger.f(
        "Reponse for the POST Request to enpoint: $endpoint \n Body Params: $data \n STATUS: ${response.statusCode} \n DATA: ${response.data}");
    return response;
  }
}

class ServerResponse<T> {
  final bool success;
  final String message;
  final T? data;

  ServerResponse({required this.success, required this.message, this.data});
}
