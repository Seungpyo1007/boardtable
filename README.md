# Boardtable

Boardtable은 Flutter로 제작된 간단한 사용자 데이터 조회 애플리케이션입니다. [Faker API](https://fakerapi.it/)를 사용하여 가상의 사용자 데이터를 불러와 테이블 형식으로 보여주고, 사용자를 검색하는 기능을 제공합니다.

## ✨ 주요 기능

- **사용자 데이터 테이블**: API로부터 받아온 사용자 목록을 테이블 형태로 표시합니다.
- **사용자 검색**: 이름, 성, 이메일을 기준으로 사용자를 실시간으로 검색할 수 있습니다.
- **데이터 캐싱**: API에서 한 번 불러온 데이터는 캐시에 저장하여, 화면 전환 시 불필요한 API 호출을 줄이고 로딩 속도를 개선했습니다.
- **하단 네비게이션**: 검색 화면과 테이블 화면을 쉽게 오갈 수 있는 UI를 제공합니다.
- **SafeArea 적용**: iPhone 등 노치가 있는 디바이스에서도 UI가 깨지지 않고 안전 영역에 표시됩니다.

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
├── main.dart         # 앱 시작점, 하단 네비게이션 설정
├── user.dart         # User 데이터 모델, API 호출 및 캐싱 로직
├── table.dart        # 사용자 데이터를 DataTable로 보여주는 화면
└── search.dart       # 사용자 목록을 검색하는 화면
```
