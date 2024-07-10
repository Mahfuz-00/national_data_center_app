class UserProfileUpdate {
  final String userId;
  final String name;
  final String organization;
  final String designation;
  final String phone;

  UserProfileUpdate({
    required this.userId,
    required this.name,
    required this.organization,
    required this.designation,
    required this.phone,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'name': name,
      'organization': organization,
      'designation': designation,
      'phone': phone,
    };
  }
}
