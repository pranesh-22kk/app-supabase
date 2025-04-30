abstract class AuthEvent {}

class SignUpEvent extends AuthEvent {
  final String email;
  final String password;
  final String role;
  final String fullName;
  final String? batch;

  SignUpEvent({
    required this.email,
    required this.password,
    required this.role,
    required this.fullName,
    this.batch,
  });
}

class SignInEvent extends AuthEvent {
  final String email;
  final String password;

  SignInEvent(this.email, this.password);
}

class SignOutEvent extends AuthEvent {}

class CheckAuthEvent extends AuthEvent {}