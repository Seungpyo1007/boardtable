import 'package:flutter/material.dart';
import 'table.dart';
import 'search.dart';
import 'value.dart';
import 'user.dart';

void main() {
  runApp(const MyApp());
}

// 앱의 루트 위젯입니다.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Data Table',
      theme: ThemeData(primarySwatch: Colors.blueGrey),
      home: const HomePage(), // 앱의 첫 화면
    );
  }
}

// 앱의 메인 화면으로, 하단 네비게이션 바와 페이지들을 관리하는 StatefulWidget 입니다.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0; // 현재 선택된 탭의 인덱스
  List<User> _users = []; // API로부터 받아온 사용자 데이터 리스트

  // ValuePage에서 데이터를 성공적으로 받아왔을 때 호출되는 콜백 함수입니다.
  void _updateUsers(List<User> newUsers) {
    setState(() {
      _users = newUsers;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('데이터가 적용되었습니다! 테이블과 검색 탭에서 확인하세요.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 페이지 목록을 build 메서드 안에서 생성하여 _users 상태 변경이
    // SearchPage와 UserDataTablePage에 즉시 반영되도록 합니다.
    final List<Widget> pages = [
      SearchPage(users: _users),       // 검색 페이지, 현재 사용자 데이터를 전달합니다.
      TablePage(users: _users), // 테이블 페이지, 현재 사용자 데이터를 전달합니다.
      ValuePage(onDataFetched: _updateUsers), // API 테스트 페이지, 데이터 업데이트 콜백 함수를 전달합니다.
    ];

    return Scaffold(
      // IndexedStack을 사용하여 탭 간의 상태를 유지합니다.
      // 탭을 전환해도 각 페이지의 스크롤 위치나 상태가 초기화되지 않습니다.
      body: IndexedStack(
        index: _selectedIndex,
        children: pages,
      ),
      // 하단 네비게이션 바입니다.
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (int index) {
          // 탭이 선택되었을 때 호출됩니다.
          setState(() {
            _selectedIndex = index; // 선택된 탭의 인덱스를 업데이트합니다.
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.search),
            label: '검색',
          ),
          NavigationDestination(
            icon: Icon(Icons.table_chart),
            label: '테이블',
          ),
          NavigationDestination(
            icon: Icon(Icons.api),
            label: 'API',
          ),
        ],
      ),
    );
  }
}
