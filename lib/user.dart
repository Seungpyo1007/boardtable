
import 'dart:convert';
import 'package:http/http.dart' as http;

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

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      firstName: json['firstname'] as String,
      lastName: json['lastname'] as String,
      email: json['email'] as String,
      phone: json['phone']?.toString() ?? '',
      gender: json['gender']?.toString() ?? '',
    );
  }
}

// 사용자 데이터를 캐시하기 위한 변수
List<User>? _cachedUsers;
const String apiUrl = 'https://fakerapi.it/api/v2/users?_quantity=30';

Future<List<User>> fetchUsers() async {
  // 캐시된 데이터가 있으면 바로 반환
  if (_cachedUsers != null) {
    return _cachedUsers!;
  }

  final response = await http.get(Uri.parse(apiUrl));
  if (response.statusCode == 200) {
    final jsonResponse = jsonDecode(response.body);
    final List usersJson = jsonResponse['data'];
    // API로부터 받은 데이터를 캐시
    _cachedUsers = usersJson.map<User>((e) => User.fromJson(e)).toList();
    return _cachedUsers!;
  } else {
    throw Exception('Failed to load user data from API');
  }
}
