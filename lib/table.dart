import 'package:flutter/material.dart';
import 'user.dart';

class TablePage extends StatelessWidget {
  final List<User> users;

  // TablePage 위젯의 생성자입니다. users 리스트를 필수로 받습니다.
  const TablePage({super.key, required this.users});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('사용자 테이블'),
      ),
      body: SafeArea(
        // users 데이터가 비어 있는지 확인합니다.
        child: users.isEmpty
            ? const Center(
                child: Text(
                  '표시할 데이터가 없습니다.\nAPI 테스트 탭에서 데이터를 가져와주세요.',
                  textAlign: TextAlign.center,
                ),
              )
            : Center(
                // 내용이 화면을 벗어날 경우를 대비해 가로/세로 스크롤을 추가합니다.
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: DataTable(
                      // 테이블의 열(Column)을 정의합니다.
                      columns: const <DataColumn>[
                        DataColumn(label: Text('ID')),
                        DataColumn(label: Text('이름')),
                        DataColumn(label: Text('성')),
                        DataColumn(label: Text('이메일')),
                        DataColumn(label: Text('전화번호')),
                        DataColumn(label: Text('성별')),
                      ],
                      // 테이블의 행(Row)을 users 데이터로부터 동적으로 생성합니다.
                      rows: users
                          .map((user) => DataRow(cells: [
                                // 각 User 객체의 속성을 DataCell 위젯으로 변환합니다.
                                DataCell(Text(user.id.toString())),
                                DataCell(Text(user.firstName)),
                                DataCell(Text(user.lastName)),
                                DataCell(Text(user.email)),
                                DataCell(Text(user.phone)),
                                DataCell(Text(user.gender)),
                              ]))
                          .toList(),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
