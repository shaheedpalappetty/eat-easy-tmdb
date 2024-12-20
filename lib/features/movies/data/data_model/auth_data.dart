import 'package:eat_easy_assignment/core/utils/imports.dart';

class AuthModel {
  final String sessionId;
  final String accountId;

  AuthModel({
    required this.sessionId,
    required this.accountId,
  });

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    return AuthModel(
      sessionId: json['session_id'],
      accountId: json['account_id'],
    );
  }

  AuthEntity toEntity() {
    return AuthEntity(
      sessionId: sessionId,
      accountId: accountId,
    );
  }
}
