class AppUser {
  final String id;
  final String role;
  final bool isApproved;
  final String? fullName;
  final String? batch;

  AppUser({
    required this.id,
    required this.role,
    required this.isApproved,
    this.fullName,
    this.batch,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['id'],
      role: json['role'],
      isApproved: json['is_approved'] ?? false,
      fullName: json['full_name'],
      batch: json['batch'],
    );
  }
}