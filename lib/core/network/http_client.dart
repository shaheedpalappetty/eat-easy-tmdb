// ignore_for_file: prefer_final_fields

import 'package:eat_easy_assignment/config.dart';
import 'package:http/http.dart' as http;
import 'package:eat_easy_assignment/core/utils/imports.dart';

class ApiService {
  // static Map<String, String> _header = {
  //   "accept": "application/json",
  //   "Authorization": "Bearer ${Config.accessToken}"
  // };
  static final Map<String, String> _header = {
    'accept': 'application/json',
    'content-type': 'application/json',
    "Authorization": "Bearer ${Config.accessToken}"
  };
  // static Future<void> _addToken() async {
  //   final token = await SharedPrefModel.instance.getData("token");
  //   if (token != null) {
  //     _header['Authorization'] = token;
  //   }
  // }

  static EitherResponse postApi(String url, Map map,
      {Map<String, dynamic>? queryParameters}) async {
    // await _addToken();
    final uri = Uri.parse(url).replace(queryParameters: queryParameters);

    final body = jsonEncode(map);
    Logger.log('POST Request: $url\n[HEADERS]: $_header\n[BODY]: $body',
        type: LogType.info);
    dynamic fetchedData;
    try {
      final response = await http.post(uri, body: body, headers: _header);

      fetchedData = await _getResponse(response);

      return Right(fetchedData);
    } on SocketException {
      Logger.log('No Internet Connection', type: LogType.error);
      return Left(InternetException());
    } on http.ClientException {
      Logger.log('Request Timeout', type: LogType.error);
      return Left(RequestTimeOutException());
    } on HandshakeException catch (e) {
      Logger.log('SSL/TLS Handshake failed: ${e.toString()}',
          type: LogType.error);
      return Left(BadRequestException("SSL Error occurred."));
    } on FormatException catch (e) {
      Logger.log('Invalid URL format: ${e.toString()}', type: LogType.error);
      return Left(BadRequestException("Invalid URL format."));
    } on Unauthorized catch (e) {
      Logger.log('UnAuthorized Request: ${e.message}', type: LogType.error);
      return Left(
          e); // Return the actual Unauthorized exception with its message
    } on BadRequestException catch (e) {
      Logger.log('Bad Request: ${e.message}', type: LogType.error);
      return Left(e);
    } catch (e, Stacktrace) {
      Logger.log('Error: $e\n[Stacktrace]$Stacktrace', type: LogType.error);
      return Left(BadRequestException(e.toString()));
    }
  }

  static EitherResponse getApi(String url,
      {Map<String, dynamic>? queryParameters}) async {
    final uri = Uri.parse(url).replace(queryParameters: queryParameters);
    // await _addToken();
    Logger.log('GET Request: $url\n[HEADERS]: $_header', type: LogType.info);
    try {
      dynamic fetchedData;

      final response = await http.get(uri, headers: _header);
      fetchedData = await _getResponse(response);
      return Right(fetchedData);
    } on SocketException catch (e) {
      Logger.log("SocketEception");
      Logger.log('Error Message: ${e.message}', type: LogType.error);
      Logger.log('OS Error: ${e.osError}', type: LogType.error);
      Logger.log('No Internet Connection', type: LogType.error);
      return Left(InternetException());
    } on http.ClientException {
      Logger.log('Request Timeout', type: LogType.error);
      return Left(RequestTimeOutException());
    } on HandshakeException catch (e) {
      Logger.log('SSL/TLS Handshake failed: ${e.toString()}',
          type: LogType.error);
      return Left(BadRequestException("SSL Error occurred."));
    } on FormatException catch (e) {
      Logger.log('Invalid URL format: ${e.toString()}', type: LogType.error);
      return Left(BadRequestException("Invalid URL format."));
    } on Unauthorized catch (e) {
      Logger.log('UnAuthorized Request: ${e.message}', type: LogType.error);
      return Left(e);
    } on BadRequestException catch (e) {
      Logger.log('Bad Request: ${e.message}', type: LogType.error);
      return Left(e);
    } catch (e, Stacktrace) {
      Logger.log('Error: $e\n[Stacktrace]$Stacktrace', type: LogType.error);
      return Left(BadRequestException(e.toString()));
    }
  }

  static EitherResponse deleteApi(String url) async {
    final uri = Uri.parse(url);
    // await _addToken();
    Logger.log('DELETE Request: $url\n[HEADERS]: $_header', type: LogType.info);
    try {
      dynamic fetchedData;
      final response = await http.delete(uri, headers: _header);
      fetchedData = await _getResponse(response);

      return Right(fetchedData);
    } on SocketException {
      Logger.log('No Internet Connection', type: LogType.error);
      return Left(InternetException());
    } on http.ClientException {
      Logger.log('Request Timeout', type: LogType.error);
      return Left(RequestTimeOutException());
    } on HandshakeException catch (e) {
      Logger.log('SSL/TLS Handshake failed: ${e.toString()}',
          type: LogType.error);
      return Left(BadRequestException("SSL Error occurred."));
    } on FormatException catch (e) {
      Logger.log('Invalid URL format: ${e.toString()}', type: LogType.error);
      return Left(BadRequestException("Invalid URL format."));
    } catch (e, Stacktrace) {
      Logger.log('Error: $e\n[Stacktrace]$Stacktrace', type: LogType.error);
      return Left(BadRequestException(e.toString()));
    }
  }

  static EitherResponse patch(String url, Map map) async {
    final uri = Uri.parse(url);
    // await _addToken();
    final body = jsonEncode(map);
    dynamic fetchedData;
    Logger.log('PATCH Request: $url\n[HEADERS]: $_header\nBody: $body',
        type: LogType.info);
    try {
      final response = await http.patch(uri, body: body, headers: _header);

      fetchedData = await _getResponse(response);

      return Right(fetchedData);
    } on SocketException {
      Logger.log('No Internet Connection', type: LogType.error);
      return Left(InternetException());
    } on http.ClientException {
      Logger.log('Request Timeout', type: LogType.error);
      return Left(RequestTimeOutException());
    } on HandshakeException catch (e) {
      Logger.log('SSL/TLS Handshake failed: ${e.toString()}',
          type: LogType.error);
      return Left(BadRequestException("SSL Error occurred."));
    } on FormatException catch (e) {
      Logger.log('Invalid URL format: ${e.toString()}', type: LogType.error);
      return Left(BadRequestException("Invalid URL format."));
    } catch (e, Stacktrace) {
      Logger.log('Error: $e\n[Stacktrace]$Stacktrace', type: LogType.error);
      return Left(BadRequestException(e.toString()));
    }
  }

  static EitherResponse put(String url, Map map) async {
    final uri = Uri.parse(url);
    // await _addToken();
    final body = jsonEncode(map);
    dynamic fetchedData;
    Logger.log('PUT Request: $url\n[HEADERS]: $_header\nBody: $body',
        type: LogType.info);

    try {
      final response = await http.put(uri, body: body, headers: _header);

      fetchedData = await _getResponse(response);

      return Right(fetchedData);
    } on SocketException {
      Logger.log('No Internet Connection', type: LogType.error);
      return Left(InternetException());
    } on http.ClientException {
      Logger.log('Request Timeout', type: LogType.error);
      return Left(RequestTimeOutException());
    } on HandshakeException catch (e) {
      Logger.log('SSL/TLS Handshake failed: ${e.toString()}',
          type: LogType.error);
      return Left(BadRequestException("SSL Error occurred."));
    } on FormatException catch (e) {
      Logger.log('Invalid URL format: ${e.toString()}', type: LogType.error);
      return Left(BadRequestException("Invalid URL format."));
    } catch (e, Stacktrace) {
      Logger.log('Error: $e\n[Stacktrace]$Stacktrace', type: LogType.error);
      return Left(BadRequestException(e.toString()));
    }
  }

  static EitherResponse patchWithoutBody(String url) async {
    final uri = Uri.parse(url);
    // await _addToken();

    dynamic fetchedData;
    Logger.log('PATCH Request: $url\n[HEADERS]: $_header', type: LogType.info);
    try {
      final response = await http.patch(uri, headers: _header);

      fetchedData = await _getResponse(response);

      return Right(fetchedData);
    } on SocketException {
      Logger.log('No Internet Connection', type: LogType.error);
      return Left(InternetException());
    } on http.ClientException {
      Logger.log('Request Timeout', type: LogType.error);
      return Left(RequestTimeOutException());
    } on HandshakeException catch (e) {
      Logger.log('SSL/TLS Handshake failed: ${e.toString()}',
          type: LogType.error);
      return Left(BadRequestException("SSL Error occurred."));
    } on FormatException catch (e) {
      Logger.log('Invalid URL format: ${e.toString()}', type: LogType.error);
      return Left(BadRequestException("Invalid URL format."));
    } catch (e, Stacktrace) {
      Logger.log('Error: $e\n[Stacktrace]$Stacktrace', type: LogType.error);
      return Left(BadRequestException(e.toString()));
    }
  }

  static _getResponse(http.Response response) async {
    try {
      final body = response.body.isNotEmpty ? jsonDecode(response.body) : null;
      Logger.log("Status Code : ${response.statusCode}");
      switch (response.statusCode) {
        case 200:
        case 201:
          Logger.log('Response: ${response.body}', type: LogType.success);
          return body;
        case 400:
          throw BadRequestException(body?['message'] ?? "Bad request error");
        case 404:
          throw BadRequestException(body?['message'] ?? "Resource not found");
        case 500:
          throw BadRequestException(
              body?['message'] ?? "Server error occurred.");
        case 401:
          throw Unauthorized(body?['message'] ?? "Unauthorized error");
        default:
          throw BadRequestException(
              body?['message'] ?? "Unknown error occurred");
      }
    } catch (e, stackTrace) {
      if (e is AppException) {
        // Re-throw known exceptions without wrapping them
        rethrow;
      }
      Logger.log('Response Parsing Error: ${e.toString()}',
          type: LogType.error);
      Logger.log('StackTrace: $stackTrace', type: LogType.error);

      // Wrap unknown exceptions in a generic BadRequestException
      throw BadRequestException("Failed to process the API response.");
    }
  }
}
