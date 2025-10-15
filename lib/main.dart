import 'package:flutter/material.dart';
import 'table.dart';
import 'search.dart';
import 'value.dart';
import 'user.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Data Table',
      theme: ThemeData(primarySwatch: Colors.blueGrey),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  List<User> _users = [];

  // ValuePage에서 데이터를 받아 앱의 상태를 업데이트하는 콜백 함수
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
    // 페이지 목록을 build 메서드 안에서 생성하여 상태 변경이 반영되도록 함
    final List<Widget> pages = [
      SearchPage(users: _users),       // 검색 페이지에 데이터 전달
      UserDataTablePage(users: _users), // 테이블 페이지에 데이터 전달
      ValuePage(onDataFetched: _updateUsers), // API 페이지에 콜백 함수 전달
    ];

    return Scaffold(
      // IndexedStack (탭 간 상태를 유지)
      body: IndexedStack(
        index: _selectedIndex,
        children: pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
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
