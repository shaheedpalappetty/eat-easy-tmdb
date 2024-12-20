import 'package:eat_easy_assignment/features/movies/domain/entities/auth_entity.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final AuthEntity auth;
  AuthSuccess(this.auth);
}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}

class AuthAuthenticated extends AuthState {}

class AuthNotAuthenticated extends AuthState {}