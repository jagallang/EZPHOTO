# 📸 REphoto v1.2.0

Flutter로 개발된 크로스플랫폼 사진 레이아웃 편집 앱입니다. 다양한 그리드 레이아웃으로 사진을 배치하고, **전문적인 겉표지와 함께** PDF 및 이미지로 내보낼 수 있습니다.

![REphoto Demo](https://img.shields.io/badge/Platform-Flutter-02569B?style=for-the-badge&logo=flutter)
![Version](https://img.shields.io/badge/Version-1.2.0-brightgreen?style=for-the-badge)
![License](https://img.shields.io/badge/License-MIT-blue?style=for-the-badge)

## ✨ 주요 기능

### 📋 NEW! 겉표지 시스템
- **7가지 전문 템플릿**: 보고서, 제안서, 앨범, 레포트, 견적서, 사진+텍스트, 텍스트전용
- **실시간 미리보기**: 템플릿 선택 즉시 미리보기 표시
- **터치 편집**: 제목, 작성자, 날짜, 기관명 등 직접 터치로 편집
- **색상 커스터마이징**: 템플릿별 고유 색상 테마
- **PDF 통합**: 겉표지가 포함된 완전한 문서 생성

### 📱 다양한 레이아웃 지원
- **1~20개 그리드**: 1개부터 20개까지 다양한 사진 그리드 레이아웃
- **세로/가로 방향**: 자동 전환 및 A4 용지 비율 최적화
- **반응형 디자인**: 다양한 화면 크기에 자동 적응

### 🖼️ 사진 편집 기능
- **드래그 이동**: 사진을 드래그하여 자유롭게 위치 조정
- **7단계 줌**: 1.0x ~ 2.5x 줌 기능 (더블터치) - **NEW!**
- **90도 회전**: 회전 버튼으로 사진 회전
- **사진 제목**: 각 사진별 개별 제목 편집
- **스마트 지우기**: 선택된 항목 삭제 또는 페이지 삭제 - **NEW!**

### 📄 다중 페이지 지원
- **무제한 페이지**: 필요한 만큼 페이지 추가
- **자동 분배**: 사진이 많을 때 자동으로 다음 페이지로 분배
- **독립적 관리**: 페이지별 독립적인 레이아웃 및 사진 관리
- **페이지 제목**: 각 페이지 제목 편집 가능

### 💾 내보내기 기능
- **고해상도 이미지**: 4배 픽셀비율의 초고해상도 PNG 저장
- **완벽한 PDF**: 겉표지 + 모든 페이지를 포함한 고품질 PDF 생성
- **형식 선택**: 저장 시 이미지 또는 PDF 형식 선택 다이얼로그
- **겉표지 포함**: 갤러리 저장 시에도 겉표지 별도 저장

### 🎯 사용자 친화적 인터페이스
- **빈 슬롯 터치**: 빈 슬롯 터치로 바로 사진 추가
- **직관적 조작**: 드래그 앤 드롭으로 쉬운 사진 편집
- **터치 최적화**: 모바일 터치 인터페이스에 최적화
- **다국어 지원**: 한국어/영어 자동 전환

## 🚀 시작하기

### 필요사항
- Flutter 3.29.2 이상
- Dart 3.7.2 이상
- Android SDK (Android 개발 시)
- Xcode (iOS 개발 시)

### 설치 및 실행

1. **저장소 클론**
   ```bash
   git clone https://github.com/jagallang/EZPHOTO.git
   cd EZPHOTO
   ```

2. **의존성 설치**
   ```bash
   flutter pub get
   ```

3. **앱 실행**
   ```bash
   # Android
   flutter run -d android
   
   # iOS
   flutter run -d ios
   
   # 웹
   flutter run -d chrome
   ```

4. **릴리즈 빌드**
   ```bash
   # Android APK (프로덕션 서명)
   flutter build apk --release
   
   # iOS 빌드
   flutter build ios --release
   
   # 웹 빌드
   flutter build web --release
   ```

## 📦 주요 의존성

| 패키지 | 버전 | 용도 |
|--------|------|------|
| `image_picker` | ^1.1.2 | 갤러리에서 사진 선택 |
| `screenshot` | ^3.0.0 | 화면 캡처로 이미지 생성 |
| `gal` | ^2.3.0 | 디바이스 갤러리 저장 |
| `pdf` | ^3.11.1 | PDF 문서 생성 |
| `printing` | ^5.13.2 | PDF 인쇄 및 공유 |
| `easy_localization` | ^3.0.7 | 다국어 지원 |
| `permission_handler` | ^11.4.0 | 권한 관리 |

## 📱 사용법

### 0. 겉표지 만들기 (NEW!)
- **겉표지 버튼**: 상단 겉표지 버튼 터치
- **템플릿 선택**: 7가지 전문 템플릿 중 선택
- **내용 편집**: 미리보기에서 각 필드 터치로 편집
- **실시간 반영**: 편집 내용이 즉시 미리보기에 반영

### 1. 사진 추가
- **빈 슬롯 터치**: 빈 슬롯을 터치하여 갤러리에서 사진 선택
- **다중 선택**: 여러 장을 한 번에 선택 가능
- **자동 분배**: 현재 페이지가 가득 차면 자동으로 다음 페이지 생성

### 2. 사진 편집
- **이동**: 사진을 드래그하여 위치 조정
- **줌**: 사진 더블터치로 7단계 줌 (1.0x ~ 2.5x)
- **회전**: 회전 버튼으로 90도씩 회전
- **제목**: 제목 영역 터치로 편집

### 3. 레이아웃 변경
- **그리드 선택**: 상단 레이아웃 버튼으로 1~20개 그리드 선택
- **페이지별 독립**: 현재 페이지만 영향을 받음
- **세로/가로**: 방향 전환 지원

### 4. 페이지 관리
- **페이지 추가**: 페이지 버튼으로 새 페이지 생성
- **페이지 이동**: 좌우 화살표로 페이지 간 이동
- **제목 편집**: 페이지 제목 터치로 편집

### 5. 내보내기
- **저장 버튼**: 저장 버튼 → 이미지 또는 PDF 선택
- **이미지**: 고해상도 PNG로 갤러리 저장
- **PDF**: 모든 페이지를 A4 크기 PDF로 생성

## 📱 지원 플랫폼

- ✅ Android (API 21+)
- ✅ iOS (12.0+)
- ✅ **Web (라이브 서비스)**: https://rephoto-88741.web.app
- ✅ Windows (10+)
- ✅ macOS (10.14+)
- ✅ Linux (Ubuntu 18.04+)

## 🔧 개발 정보

### 프로젝트 구조
```
POL_PHOTO/
├── android/              # Android 설정
│   ├── app/build.gradle.kts  # Android 빌드 설정
│   └── key.properties     # 서명 키 설정 (제외됨)
├── ios/                  # iOS 설정
├── lib/
│   └── main.dart         # 메인 앱 코드
├── assets/
│   └── translations/     # 다국어 번역 파일
├── test/                 # 테스트 코드
└── pubspec.yaml          # Flutter 의존성
```

### 아키텍처
- **UI 프레임워크**: Flutter/Material Design 3
- **상태 관리**: setState 패턴 (단순하고 직관적)
- **파일 구조**: 단일 main.dart 구조 (프로토타입 최적화)
- **서명**: 프로덕션 서명 키 적용 (com.rephoto.app)

### 데이터 모델
```dart
class PageData {
  String title;                    // 페이지 제목
  int layoutCount;                 // 그리드 개수
  Map<int, String> photoData;      // 사진 데이터
  Map<int, String> photoTitles;    // 사진 제목
  Map<int, double> photoRotations; // 사진 회전각
  Map<int, Offset> photoOffsets;   // 사진 위치
  Map<int, double> photoScales;    // 사진 줌 레벨
}

class CoverPageData {
  String template;                 // 템플릿 종류
  String title;                    // 문서 제목
  String subtitle;                 // 부제목
  String author;                   // 작성자
  String date;                     // 날짜
  String organization;             // 기관명
  Color primaryColor;              // 테마 색상
  List<String> contentLines;       // 추가 내용
}
```

## 🔐 보안 및 배포

### Android 서명 정보
- **패키지 ID**: `com.rephoto.app`
- **서명**: 프로덕션 서명 키 적용
- **API 레벨**: 최소 21 (Android 5.0)
- **권한**: 카메라, 저장소, 네트워크 상태

### iOS 설정
- **Bundle ID**: `com.rephoto.app`
- **최소 버전**: iOS 12.0
- **권한**: 사진 라이브러리 접근

## 🐛 알려진 이슈

- ⚠️ 대용량 이미지(50MB+) 처리 시 메모리 사용량 증가
- ⚠️ 웹 버전에서 파일 다운로드 시 브라우저 제한
- ⚠️ BuildContext across async gaps 경고 1개 (기능에는 영향 없음)

## 🚀 성능 최적화

- **이미지 캐싱**: 메모리 효율적인 이미지 로딩
- **지연 로딩**: 필요한 페이지만 렌더링
- **고해상도**: 4x 픽셀비율로 초고화질 내보내기
- **압축**: APK 크기 23.9MB (최적화 완료)

## 🤝 기여하기

1. 이 저장소를 포크합니다
2. 기능 브랜치를 생성합니다 (`git checkout -b feature/AmazingFeature`)
3. 변경사항을 커밋합니다 (`git commit -m 'Add some AmazingFeature'`)
4. 브랜치에 푸시합니다 (`git push origin feature/AmazingFeature`)
5. Pull Request를 생성합니다

### 개발 가이드라인
- **코드 스타일**: Flutter/Dart 공식 가이드라인 준수
- **커밋 메시지**: Conventional Commits 형식 사용
- **테스트**: 새 기능에 대한 테스트 코드 작성
- **문서**: README 및 코드 주석 업데이트

## 📄 라이선스

이 프로젝트는 MIT 라이선스 하에 배포됩니다. 자세한 내용은 `LICENSE` 파일을 참조하세요.

## 🔄 버전 히스토리

### v1.2.02 (2025-08-20) 🚀 **LATEST**
- ✏️ **파일명 입력 모달**: 웹 다운로드 시 원하는 파일명 직접 입력 가능
- ⌨️ **엔터키 다운로드**: Enter 키를 눌러 즉시 다운로드 실행
- 🎯 **자동 포커스**: 모달 열릴 때 텍스트 자동 선택 및 포커스
- 📝 **스마트 파일명**: 확장자 자동 추가 및 빈 파일명 기본값 처리
- 💚 **키보드 안내**: Enter 키 사용 안내로 직관적인 UX 제공
- 🎨 **UI 개선**: 색상 코딩과 아이콘으로 전문적인 모달 디자인
- ⚡ **빠른 워크플로우**: 키보드만으로 완전한 다운로드 프로세스

### v1.2.01 (2025-08-20)
- 🌐 **웹 다운로드 기능**: 실제 파일 다운로드로 웹 저장 기능 완전 구현
- 💾 **다운로드 모달**: 파일명, 저장위치 안내가 포함된 친화적 모달 UI
- 🖼️ **웹 미리보기 개선**: 겉표지 하단 여백 문제 해결로 깔끔한 화면 구성
- 📱 **반응형 레이아웃**: 웹에서 동적 높이 조정으로 모든 화면 크기 대응
- 🔗 **Firebase 호스팅**: https://rephoto-88741.web.app 라이브 서비스
- ⚡ **성능 최적화**: Base64 인코딩 방식으로 빠른 웹 다운로드
- 🎯 **UX 개선**: 모바일과 동일한 품질의 웹 사용자 경험 제공

### v1.2.0 (2025-01-20)
- 🔧 **배포 준비 완료**: 프로덕션 서명 키 및 패키지 ID 설정
- ✨ **코드 품질 개선**: Print 문 제거, null 체크 최적화  
- 📱 **패키지 ID 변경**: `com.example.pol_photo` → `com.rephoto.app`
- 🔐 **보안 강화**: 프로덕션 서명 키 생성 및 적용
- 🧪 **테스트 개선**: EasyLocalization 테스트 환경 구성
- 📦 **빌드 최적화**: APK 크기 24.2MB → 23.9MB 감소
- 🌍 **다국어 지원**: 한국어/영어/일본어 지원

### v1.1.22 (2025-08-17)
- 🌍 **다국어 지원**: 한국어/영어 자동 전환 (easy_localization)
- 🖼️ **이미지 저장 최적화**: 겉표지 + 모든 사진 페이지 개별 저장
- 🔧 **상태 관리 개선**: 저장 후 데이터 손실 방지 및 UI 상태 복원
- ⚡ **성능 향상**: 스크린샷 캡처 안정성 및 대기시간 최적화
- 📄 **겉표지 템플릿 수정**: Proposal 템플릿 스크롤 제거 및 A4 최적화
- 🛠️ **버그 수정**: 이미지 저장 시 사진 사라짐 현상 해결

### v2.0.0 (2025-08-17) 🎉
- 🆕 **겉표지 시스템**: 7가지 전문 템플릿 (보고서, 제안서, 앨범, 레포트, 견적서, 사진+텍스트, 텍스트전용)
- ⚡ **실시간 편집**: 템플릿 선택 즉시 미리보기, 터치로 직접 편집
- 🎨 **색상 테마**: 템플릿별 고유 색상 및 디자인
- 📄 **완전한 문서**: 겉표지가 포함된 PDF 내보내기
- 🖼️ **갤러리 통합**: 겉표지도 갤러리에 별도 저장
- 🔧 **레이아웃 수정**: RenderFlex 오류 해결, Spacer → SizedBox 교체
- 🚀 **전문성 향상**: 업무용 보고서, 제안서 작성에 최적화

---

**개발자**: Claude Code와 함께  
**프로젝트 링크**: [https://github.com/jagallang/EZPHOTO](https://github.com/jagallang/EZPHOTO)  
**최신 릴리스**: [v1.2.02 릴리스 노트](https://github.com/jagallang/EZPHOTO/releases/tag/v1.2.02)

---

<div align="center">

**🌟 이 프로젝트가 도움이 되셨다면 Star를 눌러주세요! 🌟**

</div>