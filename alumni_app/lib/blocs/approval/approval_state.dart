import 'package:alumni_app/models/user.dart';

abstract class ApprovalState {}

class ApprovalInitial extends ApprovalState {}

class ApprovalLoading extends ApprovalState {}

class ApprovalLoaded extends ApprovalState {
  final List<AppUser> alumni;

  ApprovalLoaded(this.alumni);
}

class ApprovalError extends ApprovalState {
  final String message;

  ApprovalError(this.message);
}