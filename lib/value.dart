import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'user.dart';

class ValuePage extends StatefulWidget {
  final Function(List<User>) onDataFetched;

  const ValuePage({super.key, required this.onDataFetched});

  @override
  State<ValuePage> createState() => _ValuePageState();
}

class _ValuePageState extends State<ValuePage> {
  String? _selectedResource = 'persons';
  final _quantityController = TextEditingController(text: '20');
  final _localeController = TextEditingController(text: 'ko_KR');
  final _seedController = TextEditingController();
  final _charactersController = TextEditingController();

  String _response = '';
  bool _isLoading = false;
  List<User>? _fetchedUsers;

  final List<String> _resources = [
    'persons',
    'users',
    'texts',
    'products',
    'images',
    'companies',
    'addresses',
    'credit_cards',
  ];

  Future<void> _sendRequest() async {
    setState(() {
      _isLoading = true;
      _response = '';
      _fetchedUsers = null;
    });

    var uri = Uri.parse('https://fakerapi.it/api/v2/$_selectedResource');
    final Map<String, String> queryParams = {};
    if (_quantityController.text.isNotEmpty) queryParams['_quantity'] = _quantityController.text;
    if (_localeController.text.isNotEmpty) queryParams['_locale'] = _localeController.text;
    if (_seedController.text.isNotEmpty) queryParams['_seed'] = _seedController.text;
    if (_selectedResource == 'texts' && _charactersController.text.isNotEmpty) {
      queryParams['_characters'] = _charactersController.text;
    }

    uri = uri.replace(queryParameters: queryParams);

    try {
      final response = await http.get(uri);
      if (!mounted) return;

      final jsonResponse = jsonDecode(response.body);
      setState(() {
        _response = const JsonEncoder.withIndent('  ').convert(jsonResponse);
        // 리소스가 'users' 또는 'persons'이고 요청이 성공한 경우 User 리스트로 파싱
        if ((_selectedResource == 'users' || _selectedResource == 'persons') && jsonResponse['code'] == 200) {
          final List usersJson = jsonResponse['data'];
          _fetchedUsers = usersJson.map((e) => User.fromJson(e)).toList();
        }
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _response = 'Error: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Faker API 테스트'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // --- 상단 파라미터 영역 (고정) ---
            DropdownButtonFormField<String>(
              value: _selectedResource,
              decoration: const InputDecoration(labelText: 'Resource', border: OutlineInputBorder()),
              items: _resources.map((String value) {
                return DropdownMenuItem<String>(value: value, child: Text(value));
              }).toList(),
              onChanged: (newValue) => setState(() => _selectedResource = newValue),
            ),
            const SizedBox(height: 16),
            _buildInput(_quantityController, '_quantity', TextInputType.number),
            _buildInput(_localeController, '_locale', TextInputType.text),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isLoading ? null : _sendRequest,
              style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
              child: const Text('Send Test Request'),
            ),
            const SizedBox(height: 24),
            // --- 중간 응답 결과 영역 (스크롤) ---
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _response.isNotEmpty
                      ? Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: SingleChildScrollView(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Text(_response, style: const TextStyle(fontFamily: 'monospace')),
                            ),
                          ),
                        )
                      : const SizedBox.shrink(), // 비어있을 때 공간 차지 않음
            ),
            // --- 하단 버튼 영역 (고정) ---
            if (_fetchedUsers != null && _fetchedUsers!.isNotEmpty) ...[
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => widget.onDataFetched(_fetchedUsers!),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: const Text('테이블 및 검색에 데이터 적용'),
              ),
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildInput(TextEditingController controller, String label, TextInputType inputType) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
        keyboardType: inputType,
      ),
    );
  }
}
