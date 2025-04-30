import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:alumni_app/services/supabase_service.dart';
import 'post_event.dart';
import 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final SupabaseService supabaseService;

  PostBloc(this.supabaseService) : super(PostInitial()) {
    on<LoadPosts>(_onLoadPosts);
    on<CreatePost>(_onCreatePost);
  }

  Future<void> _onLoadPosts(LoadPosts event, Emitter<PostState> emit) async {
    emit(PostLoading());
    try {
      final posts = await supabaseService.getPosts();
      emit(PostLoaded(posts));
    } catch (e) {
      emit(PostError(e.toString()));
    }
  }

  Future<void> _onCreatePost(CreatePost event, Emitter<PostState> emit) async {
    try {
      await supabaseService.createPost(event.content);
      final posts = await supabaseService.getPosts();
      emit(PostLoaded(posts));
    } catch (e) {
      emit(PostError(e.toString()));
    }
  }
}