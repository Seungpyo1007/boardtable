import 'package:flutter/material.dart';
import 'user.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<User> _users = [];
  List<User> _filteredUsers = [];
  bool _isLoading = true;
  String _query = '';

  @override
  void initState() {
    super.initState();
    // 공통 fetchUsers 함수를 호출합니다.
    fetchUsers().then((users) {
      if (mounted) { // 위젯이 여전히 마운트 상태인지 확인
        setState(() {
          _users = users;
          _filteredUsers = users;
          _isLoading = false;
        });
      }
    }).catchError((error) {
       if (mounted) {
        setState(() {
          _isLoading = false;
          // 에러 처리 (예: 스낵바 표시)
        });
      }
    });
  }

  void _filterUsers(String query) {
    _query = query;
    setState(() {
      _filteredUsers = _users
          .where((user) =>
              user.firstName.toLowerCase().contains(query.toLowerCase()) ||
              user.lastName.toLowerCase().contains(query.toLowerCase()) ||
              user.email.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextField(
                        onChanged: _filterUsers,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.search),
                          hintText: '이름, 성, 이메일로 검색',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: _filteredUsers.isEmpty
                        ? Center(child: Text(_query.isEmpty ? '검색어를 입력해주세요.' : '검색 결과가 없습니다.'))
                        : ListView.separated(
                            itemCount: _filteredUsers.length,
                            separatorBuilder: (_, __) => const Divider(height: 1),
                            itemBuilder: (context, index) {
                              final user = _filteredUsers[index];
                              return ListTile(
                                leading: CircleAvatar(
                                  child: Text(user.firstName.isNotEmpty ? user.firstName[0] : '?'),
                                ),
                                title: Text('${user.firstName} ${user.lastName}'),
                                subtitle: Text(user.email),
                                trailing: Text(user.gender),
                              );
                            },
                          ),
                  ),
                ],
              ),
      ),
    );
  }
}
