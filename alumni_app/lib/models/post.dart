class Post {
  final int id;
  final String userId;
  final String content;
  final DateTime createdAt;

  Post({
    required this.id,
    required this.userId,
    required this.content,
    required this.createdAt,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      userId: json['user_id'],
      content: json['content'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}