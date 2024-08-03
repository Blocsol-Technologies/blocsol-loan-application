import 'dart:convert';

import 'package:blocsol_loan_application/utils/logger.dart';
import 'package:dio/dio.dart';

const String serverUrl =
    "https://ondc.invoicepe.in/financial-services/invoice-based-credit";

const String baseUrl =
    "https://eaf5-2401-4900-1c70-2d18-63df-9315-563d-b22e.ngrok-free.app/financial-services/invoice-based-credit";

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
    return response;
  }
}

class ServerResponse<T> {
  final bool success;
  final String message;
  final T? data;

  ServerResponse({required this.success, required this.message, this.data});
}
