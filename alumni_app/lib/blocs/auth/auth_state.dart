import 'package:alumni_app/models/user.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final AppUser user;

  AuthAuthenticated(this.user);
}

class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);
}