import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:alumni_app/services/supabase_service.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SupabaseService supabaseService;

  AuthBloc(this.supabaseService) : super(AuthInitial()) {
    on<SignUpEvent>(_onSignUp);
    on<SignInEvent>(_onSignIn);
    on<SignOutEvent>(_onSignOut);
    on<CheckAuthEvent>(_onCheckAuth);
  }

  Future<void> _onSignUp(SignUpEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await supabaseService.signUp(
        email: event.email,
        password: event.password,
        role: event.role,
        fullName: event.fullName,
        batch: event.batch,
      );
      final user = await supabaseService.getCurrentUser();
      if (user != null) {
        emit(AuthAuthenticated(user));
      } else {
        emit(const AuthError('Failed to fetch user data'));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onSignIn(SignInEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await supabaseService.signIn(event.email, event.password);
      final user = await supabaseService.getCurrentUser();
      if (user != null) {
        if (user.role == 'alumni' && !user.isApproved) {
          emit(const AuthError('Account not approved yet'));
          await supabaseService.signOut();
        } else {
          emit(AuthAuthenticated(user));
        }
      } else {
        emit(const AuthError('Failed to fetch user data'));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onSignOut(SignOutEvent event, Emitter<AuthState> emit) async {
    await supabaseService.signOut();
    emit(AuthInitial());
  }

  Future<void> _onCheckAuth(CheckAuthEvent event, Emitter<AuthState> emit) async {
    final user = await supabaseService.getCurrentUser();
    if (user != null && (user.role != 'alumni' || user.isApproved)) {
      emit(AuthAuthenticated(user));
    } else {
      emit(AuthInitial());
    }
  }
}