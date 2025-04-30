import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:alumni_app/blocs/auth/auth_bloc.dart';
import 'package:alumni_app/blocs/post/post_bloc.dart';
import 'package:alumni_app/screens/auth/login_screen.dart';
import 'package:alumni_app/services/supabase_service.dart';

class StudentDashboard extends StatefulWidget {
  const StudentDashboard({super.key});

  @override
  _StudentDashboardState createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  final _postController = TextEditingController();

  @override
  void dispose() {
    _postController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => PostBloc(SupabaseService())..add(LoadPosts()),
        ),
        BlocProvider(create: (_) => AuthBloc(SupabaseService())),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Student Dashboard'),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                context.read<AuthBloc>().add(SignOutEvent());
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );
              },
            ),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _postController,
                      decoration: const InputDecoration(labelText: 'New Post'),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () {
                      if (_postController.text.isNotEmpty) {
pagenum: 1