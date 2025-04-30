abstract class PostEvent {}

class LoadPosts extends PostEvent {}

class CreatePost extends PostEvent {
  final String content;

  CreatePost(this.content);
}