import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'user.dart';

class ValuePage extends StatefulWidget {
  // 데이터가 성공적으로 페치되었을 때 호출되는 콜백 함수입니다.
  // User 객체의 리스트를 인자로 받습니다.
  final Function(List<User>) onDataFetched;

  // ValuePage 위젯의 생성자입니다. onDataFetched 콜백을 필수로 받습니다.
  const ValuePage({super.key, required this.onDataFetched});

  @override
  State<ValuePage> createState() => _ValuePageState();
}

class _ValuePageState extends State<ValuePage> {
  // API 요청에 사용될 상태 변수들입니다.
  String? _selectedController = 'persons'; // 선택된 API 리소스 (기본값: 'persons')
  final _quantityController = TextEditingController(text: '20');
  final _localeController = TextEditingController(text: 'ko_KR');
//  final _seedController = TextEditingController();
//  final _charactersController = TextEditingController();

  String _response = ''; // API 응답을 저장할 문자열
  bool _isLoading = false; // 로딩 상태 플래그
  List<User>? _fetchedUsers; // 페치된 사용자 데이터 리스트

  // Faker API에서 지원하는 리소스 목록입니다.
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

  // Faker API로 비동기 요청을 보내는 함수입니다.
  Future<void> _sendRequest() async {
    // 요청 시작 시 상태를 업데이트합니다. (로딩 시작, 이전 응답 초기화)
    setState(() {
      _isLoading = true;
      _response = '';
      _fetchedUsers = null;
    });

    // 선택된 리소스를 기반으로 API URI를 생성합니다.
    var uri = Uri.parse('https://fakerapi.it/api/v2/$_selectedController');
    final Map<String, String> queryParams = {};

    // 각 컨트롤러의 텍스트가 비어있지 않으면 쿼리 파라미터에 추가합니다.
    if (_quantityController.text.isNotEmpty) queryParams['_quantity'] = _quantityController.text;
    if (_localeController.text.isNotEmpty) queryParams['_locale'] = _localeController.text;
//    if (_seedController.text.isNotEmpty) queryParams['_seed'] = _seedController.text;
//    if (_selectedController == 'texts' && _charactersController.text.isNotEmpty) {
//      queryParams['_characters'] = _charactersController.text;
//    }

    // 생성된 쿼리 파라미터를 URI에 추가합니다.
    uri = uri.replace(queryParameters: queryParams);

    try {
      // HTTP GET 요청을 보냅니다.
      final response = await http.get(uri);
      // 위젯이 화면에 아직 마운트되어 있는지 확인합니다. (비동기 작업 후 필수)
      if (!mounted) return;

      // 응답 본문을 JSON으로 디코딩합니다.
      final jsonResponse = jsonDecode(response.body);
      setState(() {
        // 보기 좋게 포맷된 JSON 문자열을 _response에 저장합니다.
        _response = const JsonEncoder.withIndent('  ').convert(jsonResponse);

        // 리소스가 'users' 또는 'persons'이고 API 응답 코드가 200(성공)인 경우,
        // JSON 데이터를 User 객체 리스트로 파싱합니다.
        if ((_selectedController == 'users' || _selectedController == 'persons') && jsonResponse['code'] == 200) {
          final List usersJson = jsonResponse['data'];
          _fetchedUsers = usersJson.map((e) => User.fromJson(e)).toList();
        }
        // 로딩 상태를 종료합니다.
        _isLoading = false;
      });
    } catch (e) {
      // 에러 발생 시 처리합니다.
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
            // --- 상단 파라미터 입력 영역 ---
            // API 컨트롤러를 선택하는 드롭다운 메뉴입니다.
            DropdownButtonFormField<String>(
              value: _selectedController, // 컨트롤러 기본값 ('persons')
              decoration: const InputDecoration(labelText: 'Resource', border: OutlineInputBorder()),
              items: _resources.map((String value) {
                return DropdownMenuItem<String>(value: value, child: Text(value));
              }).toList(),
              onChanged: (newValue) => setState(() => _selectedController = newValue),
            ),
            const SizedBox(height: 16),
            // 수량(_quantity)과 지역(_locale)을 입력받는 텍스트 필드입니다.
            _buildInput(_quantityController, '_quantity', TextInputType.number),
            _buildInput(_localeController, '_locale', TextInputType.text),
//            _seed와 _characters 필드는 현재 주석 처리되어 있습니다.
//            _buildInput(_seedController, '_seed', TextInputType.text);
//            _buildInput(_charactersController, '_characters', TextInputType.number);

            const SizedBox(height: 24),
            // API 요청을 보내는 버튼입니다.
            ElevatedButton(
              onPressed: _isLoading ? null : _sendRequest,
              style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
              child: const Text('Send Test Request'),
            ),
            const SizedBox(height: 24),
            // --- 중간 응답 결과 표시 영역 ---
            Expanded(
              child: _isLoading
                  // 로딩 중이면 로딩 인디케이터를 표시합니다.
                  ? const Center(child: CircularProgressIndicator())
                  // 응답이 있으면 결과를 표시합니다.
                  : _response.isNotEmpty
                      ? Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          // 응답 내용이 길 경우를 대비해 가로/세로 스크롤이 가능하도록 합니다.
                          child: SingleChildScrollView(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Text(_response, style: const TextStyle(fontFamily: 'monospace')),
                            ),
                          ),
                        )
                      // 응답이 없으면 아무것도 표시하지 않습니다.
                      : const SizedBox.shrink(), 
            ),
            // --- 하단 데이터 적용 버튼 영역 ---
            // 페치된 사용자 데이터가 있을 경우에만 버튼을 표시합니다.
            if (_fetchedUsers != null && _fetchedUsers!.isNotEmpty) ...[
              const SizedBox(height: 16),
              ElevatedButton(
                // 버튼 클릭 시 onDataFetched 콜백을 호출하여 데이터를 부모 위젯으로 전달합니다.
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

  // TextFormField를 생성하는 헬퍼 위젯입니다.
  // 컨트롤러, 라벨, 입력 타입을 인자로 받습니다.
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
