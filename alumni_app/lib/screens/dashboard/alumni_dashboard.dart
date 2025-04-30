import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:alumni_app/blocs/auth/auth_bloc.dart';
import 'package:alumni_app/blocs/post/post_bloc.dart';
import 'package:alumni_app/screens/auth/login_screen.dart';
import 'package:alumni_app/services/supabase_service.dart';

class AlumniDashboard extends StatefulWidget {
  const AlumniDashboard({super.key});

  @override
  _AlumniDashboardState createState() => _AlumniDashboardState();
}

class _AlumniDashboardState extends State<AlumniDashboard> {
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
          title: const Text('Alumni Dashboard'),
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
                        context
                            .read<PostBloc>()
                            .add(CreatePost(_postController.text));
                        _postController.clear();
                      }
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: BlocBuilder<PostBloc, PostState>(
                builder: (context, state) {
                  if (state is PostLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is PostLoaded) {
                    return ListView.builder(
                      itemCount: state.posts.length,
                      itemBuilder: (context, index) {
                        final post = state.posts[index];
                        return ListTile(
                          title: Text(post.content),
                          subtitle:
                              Text('Posted on: ${post.createdAt.toString()}'),
                        );
                      },
                    );
                  } else if (state is PostError) {
                    return Center(child: Text('Error: ${state.message}'));
                  }
                  return const Center(child: Text('No posts available'));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}