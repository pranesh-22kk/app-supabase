import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:alumni_app/models/user.dart';
import 'package:alumni_app/models/post.dart';

class SupabaseService {
  final SupabaseClient client = Supabase.instance.client;

  // Sign up a new user
  Future<void> signUp({
    required String email,
    required String password,
    required String role,
    required String fullName,
    String? batch,
  }) async {
    final response = await client.auth.signUp(
      email: email,
      password: password,
    );
    if (response.user != null) {
      await client.from('users').insert({
        'id': response.user!.id,
        'role': role,
        'is_approved': role == 'alumni' ? false : true,
        'full_name': fullName,
        'batch': batch,
      });
    }
  }

  // Sign in a user
  Future<void> signIn(String email, String password) async {
    await client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  // Sign out
  Future<void> signOut() async {
    await client.auth.signOut();
  }

  // Get current user data
  Future<AppUser?> getCurrentUser() async {
    final user = client.auth.currentUser;
    if (user == null) return null;
    final response = await client
        .from('users')
        .select()
        .eq('id', user.id)
        .single();
    return AppUser.fromJson(response);
  }

  // Get unapproved alumni
  Future<List<AppUser>> getUnapprovedAlumni() async {
    final response = await client
        .from('users')
        .select()
        .eq('role', 'alumni')
        .eq('is_approved', false);
    return (response as List).map((json) => AppUser.fromJson(json)).toList();
  }

  // Approve alumni
  Future<void> approveAlumni(String userId) async {
    await client
        .from('users')
        .update({'is_approved': true})
        .eq('id', userId);
  }

  // Create a post
  Future<void> createPost(String content) async {
    final user = client.auth.currentUser;
    if (user == null) return;
    await client.from('posts').insert({
      'user_id': user.id,
      'content': content,
    });
  }

  // Get all posts
  Future<List<Post>> getPosts() async {
    final response = await client.from('posts').select();
    return (response as List).map((json) => Post.fromJson(json)).toList();
  }
}