import 'package:flutter/material.dart';
import 'user.dart';

class SearchPage extends StatefulWidget {
  // HomePage로부터 사용자 데이터 리스트를 전달받음
  final List<User> users;

  const SearchPage({super.key, required this.users});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<User> _filteredUsers = []; // 필터링된 사용자 리스트
  String _query = '';

  @override
  void initState() {
    super.initState();
    // 처음에는 전체 사용자 목록을 보여줌
    _filteredUsers = widget.users;
  }

  // 부모 위젯에서 전달받은 데이터(props)가 변경될 때 호출됨
  @override
  void didUpdateWidget(SearchPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    // HomePage의 상태가 변경되어 새로운 user 리스트가 전달되면 UI를 업데이트함
    if (widget.users != oldWidget.users) {
      _filterUsers(_query); // 현재 검색어로 다시 필터링
    }
  }

  void _filterUsers(String query) {
    _query = query;
    setState(() {
      _filteredUsers = widget.users
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                onChanged: _filterUsers,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: '이름, 성, 이메일로 검색',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  filled: true,
                  fillColor: Colors.grey.shade200,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
            Expanded(
              child: widget.users.isEmpty
                  ? const Center(child: Text('표시할 데이터가 없습니다. API 테스트 탭에서 데이터를 가져와주세요.', textAlign: TextAlign.center))
                  : _filteredUsers.isEmpty
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
                              onTap: () {
                                // 전화번호가 비어있지 않은 경우에만 스낵바를 표시
                                if (user.phone.isNotEmpty) {
                                  // 기존 스낵바가 있다면 지우고 새로 표시
                                  ScaffoldMessenger.of(context).removeCurrentSnackBar();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('전화번호: ${user.phone}'),
                                      duration: const Duration(seconds: 2),
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).removeCurrentSnackBar();
                                   ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('전화번호 정보가 없습니다.'),
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                }
                              },
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
