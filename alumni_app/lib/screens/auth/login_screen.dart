import 'package:flutter/material.dart';
import 'package:alumni_app/screens/auth/admin_login_screen.dart';
import 'package:alumni_app/screens/auth/alumni_login_screen.dart';
import 'package:alumni_app/screens/auth/student_login_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Alumni App')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Select User Type',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AdminLoginScreen()),
                );
              },
              child: const Text('Admin Login'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AlumniLoginScreen()),
                );
              },
              child: const Text('Alumni Login/Sign Up'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const StudentLoginScreen()),
                );
              },
              child: const Text('Student Login/Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}