import 'package:flutter/material.dart';
import 'user.dart';

class UserDataTablePage extends StatelessWidget {
  final List<User> users;

  const UserDataTablePage({super.key, required this.users});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('사용자 테이블'),
      ),
      body: SafeArea(
        child: users.isEmpty
            ? const Center(
                child: Text(
                  '표시할 데이터가 없습니다.\nAPI 테스트 탭에서 데이터를 가져와주세요.',
                  textAlign: TextAlign.center,
                ),
              )
            : Center(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: DataTable(
                      columns: const <DataColumn>[
                        DataColumn(label: Text('ID')),
                        DataColumn(label: Text('이름')),
                        DataColumn(label: Text('성')),
                        DataColumn(label: Text('이메일')),
                        DataColumn(label: Text('전화번호')),
                        DataColumn(label: Text('성별')),
                      ],
                      rows: users
                          .map((user) => DataRow(cells: [
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
