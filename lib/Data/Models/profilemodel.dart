class UserProfile {
  final String name;
  final String organization;
  final String photo;
  final String user;

  UserProfile({
    required this.name,
    required this.organization,
    required this.photo,
    required this.user,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      name: json['name'],
      organization: json['organization'],
      photo: json['photo'],
      user: json['userType'],
    );
  }
}