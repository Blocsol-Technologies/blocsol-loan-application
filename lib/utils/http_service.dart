import 'dart:convert';

import 'package:blocsol_loan_application/utils/logger.dart';
import 'package:dio/dio.dart';

const String invoiceLoanServerUrl =
    "https://ondc.invoicepe.in/financial-services/invoice-based-credit";

const String personalLoanServerUrl =
    "https://ondc.invoicepe.in/financial-services/invoice-based-credit";

const String invoiceLoanbaseUrl =
    "https://ondc.invoicepe.in/financial-services/invoice-based-credit";

const String personalLoanbaseUrl =
    "https://ondc.invoicepe.in/financial-services/personal-credit";

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
