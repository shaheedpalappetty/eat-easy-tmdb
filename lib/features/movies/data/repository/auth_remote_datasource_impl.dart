import 'package:eat_easy_assignment/core/utils/imports.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl();
  @override
  Future<String> getRequestToken() async {
    final response = await ApiService.get(
      '${NetworkRoutes.baserUrl}${NetworkRoutes.requestToken}',
    );

    return response.fold(
      (error) => throw Exception(error.message),
      (data) {
        if (data['success'] == true && data['request_token'] != null) {
          return data['request_token'] as String;
        }
        throw Exception('Invalid response format for request token');
      },
    );
  }

  @override
  Future<String> createSession(String requestToken) async {
    final response = await ApiService.post(
      '${NetworkRoutes.baserUrl}${NetworkRoutes.createSession}',
      {'request_token': requestToken},
    );

    return response.fold(
      (error) => throw Exception(error.message),
      (data) {
        if (data['success'] == true && data['session_id'] != null) {
          return data['session_id'] as String;
        }
        throw Exception('Invalid response format for session creation');
      },
    );
  }

  @override
  Future<String> getAccountId(String sessionId) async {
    final response = await ApiService.get(
      '${NetworkRoutes.baserUrl}account',
      queryParameters: {'session_id': sessionId},
    );

    return response.fold(
      (error) => throw Exception(error.message),
      (data) {
        if (data['id'] != null) {
          return data['id'].toString();
        }
        throw Exception('Invalid response format for account ID');
      },
    );
  }
}
