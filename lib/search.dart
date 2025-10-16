import 'package:flutter/material.dart';
import 'user.dart';

class SearchPage extends StatefulWidget {
  final List<User> users;


  // SearchPage 위젯의 생성자입니다. users 리스트를 필수로 받습니다.
  const SearchPage({super.key, required this.users});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<User> _filteredUsers = []; // 검색 쿼리에 따라 필터링된 사용자 리스트
  String _query = ''; // 현재 검색어

  @override
  void initState() {
    super.initState();
    // 위젯이 처음 생성될 때, 전체 사용자 목록으로 필터링된 리스트를 초기화합니다.
    _filteredUsers = widget.users;
  }

  // 부모 위젯(HomePage)에서 전달받은 데이터가 변경될 때 호출됩니다.
  @override
  void didUpdateWidget(SearchPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    // HomePage의 상태가 변경되어 새로운 user 리스트가 전달되면 UI를 업데이트합니다.
    if (widget.users != oldWidget.users) {
      // 현재 검색어를 사용하여 새로운 사용자 리스트를 다시 필터링합니다.
      _filterUsers(_query);
    }
  }

  // 검색 쿼리를 받아 사용자 데이터를 필터링하는 함수입니다.
  void _filterUsers(String query) {
    _query = query; // 현재 검색어 업데이트
    setState(() {
      // widget.users (전체 목록)에서 이름, 성, 이메일이 쿼리를 포함하는 사용자를 찾습니다. (대소문자 구분 없음)
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
            // --- 상단 검색창 영역 ---
            Padding(
              padding: const EdgeInsets.all(1.0),
              child: TextField(
                // 텍스트가 변경될 때마다 _filterUsers 함수를 호출합니다.
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
            // --- 하단 검색 결과 리스트 영역 ---
            Expanded(
              // 전체 사용자 데이터가 비어 있는지 확인합니다.
              child: widget.users.isEmpty
                  ? const Center(child: Text('표시할 데이터가 없습니다.\nAPI 테스트 탭에서 데이터를 가져와주세요.', textAlign: TextAlign.center))
                  // 필터링된 결과가 비어 있는지 확인합니다.
                  : _filteredUsers.isEmpty
                      ? Center(child: Text(_query.isEmpty ? '검색어를 입력해주세요.' : '검색 결과가 없습니다.'))
                      : ListView.separated(
                          itemCount: _filteredUsers.length,
                          separatorBuilder: (_, __) => const Divider(height: 1), // 각 항목 사이에 구분선 추가
                          itemBuilder: (context, index) {
                            final user = _filteredUsers[index];
                            return ListTile(
                              // 사용자 이름의 첫 글자를 아바타로 표시합니다.
                              leading: CircleAvatar(
                                child: Text(user.firstName.isNotEmpty ? user.firstName[0] : '?'),
                              ),
                              title: Text('${user.firstName} ${user.lastName}'),
                              subtitle: Text(user.email),
                              trailing: Text(user.gender),
                              // 리스트를 탭했을 때의 동작입니다.
                              onTap: () {
                                // 전화번호가 있는 경우에만 스낵바를 표시합니다.
                                if (user.phone.isNotEmpty) {
                                  // 기존에 표시된 스낵바가 있다면 제거합니다.
                                  ScaffoldMessenger.of(context).removeCurrentSnackBar();
                                  // 전화번호를 포함한 새 스낵바를 표시합니다.
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('전화번호: ${user.phone}'),
                                      duration: const Duration(seconds: 2),
                                    ),
                                  );
                                } else {
                                  // 전화번호가 없는 경우 안내 스낵바를 표시합니다.
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
