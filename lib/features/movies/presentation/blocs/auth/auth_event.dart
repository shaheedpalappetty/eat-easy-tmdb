import 'package:eat_easy_assignment/core/utils/imports.dart';

abstract class AuthEvent {}

class GenerateSessionEvent extends AuthEvent {
  final BuildContext context;

  GenerateSessionEvent({required this.context});
}

class CheckAuthStatusEvent extends AuthEvent {}
