class User {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String gender;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.gender,
  });

  // API 응답 JSON을 User 객체로 변환하는 팩토리 메서드
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      firstName: json['firstname']?.toString() ?? json['username']?.toString() ?? '',
      lastName: json['lastname']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      gender: json['gender']?.toString() ?? '',
    );
  }
}
