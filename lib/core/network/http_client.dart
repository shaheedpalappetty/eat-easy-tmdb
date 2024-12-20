import 'package:http/http.dart' as http;
import 'package:eat_easy_assignment/core/utils/imports.dart';

class ApiService {
  static final Map<String, String> _header = {
    'accept': 'application/json',
    'content-type': 'application/json',
    "Authorization": "Bearer ${Config.accessToken}"
  };

  static Future<Either<AppException, dynamic>> post(
      String url, Map<String, dynamic> body,
      {Map<String, dynamic>? queryParameters}) async {
    final uri = Uri.parse(url).replace(queryParameters: queryParameters);
    final requestBody = jsonEncode(body);
    Logger.log('POST Request: $url\n[HEADERS]: $_header\n[BODY]: $requestBody',
        type: LogType.info);

    try {
      final response =
          await http.post(uri, body: requestBody, headers: _header);
      return _handleResponse(response);
    } catch (e) {
      return Left(_handleError(e));
    }
  }

  static Future<Either<AppException, dynamic>> get(String url,
      {Map<String, dynamic>? queryParameters}) async {
    final uri = Uri.parse(url).replace(queryParameters: queryParameters);
    Logger.log('GET Request: $url\n[HEADERS]: $_header', type: LogType.info);

    try {
      final response = await http.get(uri, headers: _header);
      return _handleResponse(response);
    } catch (e) {
      return Left(_handleError(e));
    }
  }

  static Either<AppException, dynamic> _handleResponse(http.Response response) {
    try {
      final body = response.body.isNotEmpty ? jsonDecode(response.body) : null;
      Logger.log("Status Code : ${response.statusCode}");

      switch (response.statusCode) {
        case 200:
        case 201:
          Logger.log('Response: ${response.body}', type: LogType.success);
          return Right(body);
        case 400:
          return Left(BadRequestException(
              body?['status_message'] ?? "Bad request error"));
        case 404:
          return Left(BadRequestException(
              body?['status_message'] ?? "Resource not found"));
        case 500:
          return Left(ServerErrorException(
              body?['status_message'] ?? "Server error occurred."));
        case 401:
          return Left(
              Unauthorized(body?['status_message'] ?? "Unauthorized error"));
        default:
          return Left(AppException(
              body?['status_message'] ?? "Unknown error occurred"));
      }
    } catch (e) {
      Logger.log('Response Parsing Error: ${e.toString()}',
          type: LogType.error);
      return Left(AppException("Failed to process the API response."));
    }
  }

  static AppException _handleError(dynamic error) {
    if (error is SocketException) {
      Logger.log('No Internet Connection', type: LogType.error);
      return InternetException();
    } else if (error is http.ClientException) {
      Logger.log('Request Timeout', type: LogType.error);
      return RequestTimeOutException();
    } else if (error is HandshakeException) {
      Logger.log('SSL/TLS Handshake failed: ${error.toString()}',
          type: LogType.error);
      return BadRequestException("SSL Error occurred.");
    } else if (error is FormatException) {
      Logger.log('Invalid URL format: ${error.toString()}',
          type: LogType.error);
      return BadRequestException("Invalid URL format.");
    } else {
      Logger.log('Unknown Error: ${error.toString()}', type: LogType.error);
      return AppException("An unexpected error occurred.");
    }
  }
}
