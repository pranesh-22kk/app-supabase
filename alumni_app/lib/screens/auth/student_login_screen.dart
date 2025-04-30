import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:alumni_app/blocs/auth/auth_bloc.dart';
import 'package:alumni_app/screens/dashboard/student_dashboard.dart';
import 'package:alumni_app/services/supabase_service.dart';

class StudentLoginScreen extends StatefulWidget {
  const StudentLoginScreen({super.key});

  @override
  _StudentLoginScreenState createState() => _StudentLoginScreenState();
}

class _StudentLoginScreenState extends State<StudentLoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _fullNameController = TextEditingController();
  bool _isSignUp = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _fullNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthBloc(SupabaseService()),
      child: Scaffold(
        appBar: AppBar(title: const Text('Student Login/Sign Up')),
        body: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            } else if (state is AuthAuthenticated) {
              if (state.user.role == 'student') {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const StudentDashboard()),
                );
              }
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                  ),
                  TextField(
                    controller: _passwordController,
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText: true,
                  ),
                  if (_isSignUp)
                    TextField(
                      controller: _fullNameController,
                      decoration: const InputDecoration(labelText: 'Full Name'),
                    ),
                  const SizedBox(height: 20),
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      return ElevatedButton(
                        onPressed: state is AuthLoading
                            ? null
                            : () {
                                if (_isSignUp) {
                                  context.read<AuthBloc>().add(SignUpEvent(
                                        email: _emailController.text,
                                        password: _passwordController.text,
                                        role: 'student',
                                        fullName: _fullNameController.text,
                                      ));
                                } else {
                                  context.read<AuthBloc>().add(SignInEvent(
                                        _emailController.text,
                                        _passwordController.text,
                                      ));
                                }
                              },
                        child: state is AuthLoading
                            ? const CircularProgressIndicator()
                            : Text(_isSignUp ? 'Sign Up' : 'Login'),
                      );
                    },
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _isSignUp = !_isSignUp;
                      });
                    },
                    child: Text(_isSignUp
                        ? 'Already have an account? Login'
                        : 'No account? Sign Up'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}