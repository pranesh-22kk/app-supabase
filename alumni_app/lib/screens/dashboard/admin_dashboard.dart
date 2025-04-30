import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:alumni_app/blocs/approval/approval_bloc.dart';
import 'package:alumni_app/blocs/auth/auth_bloc.dart';
import 'package:alumni_app/screens/auth/login_screen.dart';
import 'package:alumni_app/services/supabase_service.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => ApprovalBloc(SupabaseService())..add(LoadUnapprovedAlumni()),
        ),
        BlocProvider(create: (_) => AuthBloc(SupabaseService())),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Admin Dashboard'),
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
        body: BlocBuilder<ApprovalBloc, ApprovalState>(
          builder: (context, state) {
            if (state is ApprovalLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ApprovalLoaded) {
              return ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: state.alumni.length,
                itemBuilder: (context, index) {
                  final alumni = state.alumni[index];
                  return ListTile(
                    title: Text(alumni.fullName ?? 'Unknown'),
                    subtitle: Text('Batch: ${alumni.batch ?? 'N/A'}'),
                    trailing: ElevatedButton(
                      onPressed: () {
                        context.read<ApprovalBloc>().add(ApproveAlumni(alumni.id));
                      },
                      child: const Text('Approve'),
                    ),
                  );
                },
              );
            } else if (state is ApprovalError) {
              return Center(child: Text('Error: ${state.message}'));
            }
            return const Center(child: Text('No pending approvals'));
          },
        ),
      ),
    );
  }
}