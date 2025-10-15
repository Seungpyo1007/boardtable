# boardtable

boardtable은 Flutter로 제작된 간단한 사용자 데이터 조회 애플리케이션입니다. [Faker API](https://fakerapi.it/)를 사용하여 가상의 사용자 데이터를 동적으로 요청하고, 테이블과 검색 목록 형태로 데이터를 조회하는 기능을 제공합니다. 상태 관리를 통해 여러 화면에서 데이터를 일관성 있게 보여줍니다.

## ✨ 주요 기능

- **API 테스트 및 데이터 생성**: `Faker API`의 다양한 리소스와 파라미터를 직접 조합하여 테스트 요청을 보내고 실시간으로 JSON 응답을 확인할 수 있습니다.
- **중앙 집중식 상태 관리**: `HomePage`를 중심으로 앱의 상태(`사용자 목록`)를 관리합니다. API 테스트 페이지에서 생성된 데이터는 앱의 모든 화면(테이블, 검색)에 즉시 반영됩니다.
- **탭 상태 유지**: `IndexedStack`을 사용하여 탭을 전환해도 각 화면의 스크롤 위치나 입력 상태가 그대로 유지됩니다.
- **사용자 데이터 테이블**: API로부터 받아온 사용자 목록을 테이블 형태로 표시합니다.
- **사용자 검색**: 이름, 성, 이메일을 기준으로 사용자를 실시간으로 검색할 수 있습니다.
- **상세 정보 확인**: 검색 목록에서 사용자를 탭하면 스낵바(Snackbar)를 통해 해당 사용자의 전화번호를 확인할 수 있습니다.

## 🚀 시작하기

### 준비물

- [Flutter SDK](https://flutter.dev/docs/get-started/install)

### 설치 및 실행

1.  **저장소 복제**
    ```sh
    git clone https://github.com/your-username/boardtable.git
    ```

2.  **프로젝트 폴더로 이동**
    ```sh
    cd boardtable
    ```

3.  **Flutter 패키지 설치**
    ```sh
    flutter pub get
    ```

4.  **앱 실행**
    ```sh
    flutter run
    ```

## 🛠️ 사용된 기술

- Flutter
- Dart
- [http](https://pub.dev/packages/http) - REST API 통신

## 📂 파일 구조

```
lib/
├── main.dart         # 앱 시작점, HomePage와 하단 네비게이션, 전역 상태 관리
├── user.dart         # User 데이터 모델 및 JSON 파싱 로직
├── value.dart        # Faker API 요청을 보내고 결과를 확인하는 API 테스트 화면
├── table.dart        # 사용자 데이터를 DataTable로 보여주는 화면 (상태를 갖지 않음)
└── search.dart       # 사용자 목록을 검색하고, 탭하여 상세 정보를 보는 화면
```
