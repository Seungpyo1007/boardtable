# boardtable

boardtable은 Flutter로 제작된 간단한 사용자 데이터 조회 애플리케이션입니다. [Faker API](https://fakerapi.it/)를 사용하여 가상의 사용자 데이터를 동적으로 요청하고, 테이블과 검색 목록 형태로 데이터를 조회하는 기능을 제공합니다. 상태 관리를 통해 여러 화면에서 데이터를 일관성 있게 보여줍니다.

## 스크린샷

### 메인 화면
<img width="296" height="640" alt="Image" src="https://github.com/user-attachments/assets/e341ce8a-1878-446c-922e-ba2cf379d5e8" />
<img width="296" height="640" alt="Image" src="https://github.com/user-attachments/assets/43e54a8d-10cb-4007-822f-c92c3c676675" />

### API 받는 화면
<img width="296" height="640" alt="Image" src="https://github.com/user-attachments/assets/fbfd0d95-ad89-4317-a70a-2a0914f44546" />
<img width="296" height="640" alt="Image" src="https://github.com/user-attachments/assets/512ba550-57ff-4620-9998-d30952a4709f" />

### API 받은 화면
<img width="296" height="640" alt="Image" src="https://github.com/user-attachments/assets/c16eeefe-1191-4d33-a232-3e4c7c97905e" />
<img width="296" height="640" alt="Image" src="https://github.com/user-attachments/assets/522ca1e2-6581-444d-9e97-36da1351b805" />

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
    git clone https://github.com/Seungpyo1007/boardtable.git
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

## 📜 라이선스

이 프로젝트는 MIT 라이선스 하에 배포됩니다. 자세한 내용은 `LICENSE` 파일을 참조하십시오.
### Copyright (c) 2026 Seungpyo1007
