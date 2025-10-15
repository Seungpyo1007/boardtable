// 사용자 데이터 모델을 정의하는 클래스입니다.
class User {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String gender;

  // User 객체 생성자
  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.gender,
  });

  // JSON 데이터를 User 객체로 변환하는 팩토리 생성자입니다.
  // API 응답에서 'persons'와 'users' 리소스의 필드 이름 차이를 처리합니다.
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      // 'firstname'이 없으면 'username'을 사용하고, 둘 다 없으면 빈 문자열을 할당합니다.
      firstName: json['firstname']?.toString() ?? json['username']?.toString() ?? '',
      lastName: json['lastname']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      gender: json['gender']?.toString() ?? '',
    );
  }
}
