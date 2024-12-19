class AppException implements Exception {
  final String message;
  AppException(this.message);
}

class InternetException extends AppException {
  InternetException() : super('No internet connection');
  @override
  String toString() => message;
}

class RequestTimeOutException extends AppException {
  RequestTimeOutException() : super('Request time out');
  @override
  String toString() => "Request Timeout: $message";
}

class BadRequestException extends AppException {
  BadRequestException(super.message);
  @override
  String toString() => "Bad Request: $message";
}

class Unauthorized extends AppException {
  Unauthorized(super.message);
  @override
  String toString() => "Unauthorized: $message";
}
