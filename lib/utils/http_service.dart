import 'dart:convert';

import 'package:blocsol_loan_application/utils/logger.dart';
import 'package:dio/dio.dart';

const String serverUrl =
    "https://ondc.invoicepe.in/financial-services/invoice-based-credit";

const String baseUrl =
    "https://47a0-2401-4900-1c71-9ac9-a58e-1af5-5d34-afe4.ngrok-free.app/financial-services/invoice-based-credit";

class HttpService {
  late Dio _dio;

  HttpService() {
    _dio = Dio(BaseOptions(baseUrl: baseUrl));
    _dio.options.receiveTimeout = const Duration(minutes: 5);
  }

  Future<Response> get(String endpoint, String authToken,
      CancelToken cancelToken, Map<String, String> queryParams) async {
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
