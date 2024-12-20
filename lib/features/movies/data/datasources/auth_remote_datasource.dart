import 'package:eat_easy_assignment/core/network/http_client.dart';
import 'package:eat_easy_assignment/core/network/network_routes.dart';

abstract class AuthRemoteDataSource {
  Future<String> getRequestToken();
  Future<String> createSession(String requestToken);
  Future<String> getAccountId(String sessionId);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
 

  AuthRemoteDataSourceImpl();
  @override
  Future<String> getRequestToken() async {
    final response = await ApiService.get(
      '${NetworkRoutes.baserUrl}authentication/token/new', // Removed base URL as it should be handled in ApiService
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
      '${NetworkRoutes.baserUrl}authentication/session/new',
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

  // @override
  // Future<String> getRequestToken() async {
  //   final response = await ApiService.getApi(
  //     '${NetworkRoutes.baserUrl}/authentication/token/new',
  //   );

  //   return response.fold(
  //     (error) => throw Exception(error.message),
  //     (data) => data['request_token'] as String,
  //   );
  // }

  // @override
  // Future<String> createSession(String requestToken) async {
  //   final response = await ApiService.postApi(
  //     '${NetworkRoutes.baserUrl}/authentication/session/new',
  //     {'request_token': requestToken},
  //   );

  //   return response.fold(
  //     (error) => throw Exception(error.message),
  //     (data) => data['session_id'] as String,
  //   );
  // }

  // @override
  // Future<String> getAccountId(String sessionId) async {
  //   final response = await ApiService.getApi(
  //     '${NetworkRoutes.baserUrl}/account',
  //     queryParameters: {'session_id': sessionId},
  //   );

  //   return response.fold(
  //     (error) => throw Exception(error.message),
  //     (data) => data['id'].toString(),
  //   );
  // }

