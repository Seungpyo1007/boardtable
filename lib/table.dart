import 'package:flutter/material.dart';
import 'user.dart';

class UserDataTablePage extends StatefulWidget {
  const UserDataTablePage({super.key});

  @override
  State<UserDataTablePage> createState() => _UserDataTablePageState();
}

class _UserDataTablePageState extends State<UserDataTablePage> {
  late Future<List<User>> futureUsers;

  @override
  void initState() {
    super.initState();
    futureUsers = fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: FutureBuilder<List<User>>(
              future: futureUsers,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('에러: ${snapshot.error}');
                } else if (snapshot.hasData) {
                  final users = snapshot.data!;
                  return DataTable(
                    headingRowColor: WidgetStateProperty.resolveWith((states) => Colors.blue.shade100),
                    border: TableBorder.all(color: Colors.grey.shade300, width: 1),
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
                  );
                } else {
                  return const Text('실패!');
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
