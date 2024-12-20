import 'package:eat_easy_assignment/features/movies/domain/auth_repository.dart';
import 'package:eat_easy_assignment/features/movies/presentation/blocs/auth/auth_event.dart';
import 'package:eat_easy_assignment/features/movies/presentation/blocs/auth/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    on<GenerateSessionEvent>(_onGenerateSession);
    on<CheckAuthStatusEvent>(_onCheckAuthStatus);
  }

  Future<void> _onGenerateSession(
    GenerateSessionEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result =
        await authRepository.generateSessionId(context: event.context);
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (auth) => emit(AuthSuccess(auth)),
    );
  }

  Future<void> _onCheckAuthStatus(
    CheckAuthStatusEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await authRepository.getStoredSessionId();
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (sessionId) => emit(
          sessionId != null ? AuthAuthenticated() : AuthNotAuthenticated()),
    );
  }
}
