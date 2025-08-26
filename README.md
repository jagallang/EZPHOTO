# 📸 REphoto - 폴라로이드 프레임 앱

<p align="center">
  <img src="https://github.com/jagallang/EZPHOTO/blob/main/assets/app_icon.png?raw=true" width="128" height="128" alt="REphoto Logo">
</p>

<p align="center">
  <strong>사진을 예술로 만드는 폴라로이드 프레임 앱</strong>
</p>

<p align="center">
  <a href="https://rephoto-88741.web.app">🌐 웹 버전 체험하기</a> |
  <a href="https://play.google.com/store/apps">📱 Google Play</a> |
  <a href="#features">✨ 주요 기능</a> |
  <a href="#screenshots">📸 스크린샷</a>
</p>

---

## 🎯 개요

**REphoto**는 평범한 사진을 감성적인 폴라로이드 스타일로 변환해주는 Flutter 기반 크로스플랫폼 앱입니다. 직관적인 UI로 누구나 쉽게 멋진 추억의 앨범을 만들 수 있습니다.

### 🌟 핵심 가치
- **간편성**: 복잡한 설정 없이 3단계로 완성
- **품질**: 고해상도 이미지 출력 지원
- **다양성**: 1~4장 다양한 레이아웃 제공
- **접근성**: 웹/모바일 멀티플랫폼 지원

## ✨ 주요 기능

### 📱 핵심 기능
- **🖼️ 폴라로이드 프레임**: 클래식한 즉석 사진 느낌
- **📐 다양한 레이아웃**: 1장, 2장, 3장, 4장 분할 레이아웃
- **🔄 방향 설정**: 세로형/가로형 자유 선택
- **🎨 사진 편집**: 확대/축소/회전/위치 조정
- **📑 멀티페이지**: 여러 페이지로 구성된 앨범 제작
- **🏷️ 제목 편집**: 각 페이지별 맞춤 제목 설정

### 🛠️ 고급 기능
- **📄 PDF 생성**: 프로페셔널한 문서 형태로 저장
- **💾 고품질 저장**: 원본 품질 유지하여 갤러리 저장
- **🌐 웹 지원**: 브라우저에서 바로 사용 가능
- **📱 반응형 UI**: 다양한 화면 크기 최적화
- **🔧 설정**: 언어, 품질 등 개인화 설정
- **📄 견적서 생성**: 프로페셔널한 비즈니스 견적서 작성
- **🖼️ 로고 업로드**: 견적서에 회사 로고 이미지 첨부
- **💰 금액 편집**: Total Amount 자유 입력 (금액/협의/TBD 등)

### 🎭 사용자 경험
- **🚀 빠른 처리**: 실시간 미리보기 제공
- **💡 직관적 UI**: 누구나 쉽게 사용 가능한 인터페이스
- **🔒 프라이버시**: 모든 처리가 기기 내부에서만 진행
- **📋 개인정보보호**: 투명한 개인정보처리방침 제공

## 🏗️ 기술 스택

### Frontend
- **Flutter 3.29.2**: 크로스플랫폼 UI 프레임워크
- **Dart 3.7.2**: 프로그래밍 언어

### 핵심 패키지
- **image_picker**: 사진 선택/촬영 기능
- **screenshot**: 화면 캡처 및 이미지 생성
- **gal**: 갤러리 저장 (모바일)
- **pdf**: PDF 문서 생성
- **printing**: 인쇄 및 공유 기능
- **easy_localization**: 다국어 지원

### 배포 & 인프라
- **Firebase Hosting**: 웹 앱 호스팅
- **Google Play Store**: Android 앱 배포
- **R8 최적화**: 코드 난독화 및 크기 최적화

## 🚀 설치 및 실행

### 📋 요구사항
- Flutter SDK 3.29.2+
- Dart SDK 3.7.2+
- Android Studio / Xcode (모바일 개발)
- Node.js (웹 배포)

### 🔧 개발 환경 설정
```bash
# 1. 저장소 클론
git clone https://github.com/jagallang/EZPHOTO.git
cd EZPHOTO

# 2. 의존성 설치
flutter pub get

# 3. 코드 생성 (필요시)
flutter packages pub run build_runner build
```

### ▶️ 실행 방법

#### 모바일 개발
```bash
# Android 실행
flutter run -d android

# iOS 실행 (macOS에서만)
flutter run -d ios

# 디버그 빌드
flutter build apk --debug

# 릴리스 빌드
flutter build apk --release
```

#### 웹 개발
```bash
# 웹 개발 서버 실행
flutter run -d chrome

# 웹 빌드
flutter build web

# Firebase 배포
firebase deploy
```

## 📱 플랫폼별 특징

### 🤖 Android
- **최소 SDK**: 21 (Android 5.0)
- **대상 SDK**: 최신
- **권한**: 카메라, 저장소 접근
- **최적화**: R8 코드 압축 및 난독화

### 🍎 iOS
- **최소 버전**: iOS 12.0+
- **아키텍처**: arm64, x86_64
- **권한**: 사진 라이브러리, 카메라 접근

### 🌐 웹
- **지원 브라우저**: Chrome, Firefox, Safari, Edge
- **반응형**: 데스크톱/태블릿/모바일 최적화
- **PWA**: 프로그레시브 웹 앱 지원

## 🆕 최신 업데이트 (v1.2.12)

### ✨ 새로운 기능
- **💰 Total Amount 편집**: 견적서 하단 Total Amount 영역 클릭으로 사용자 정의 금액/텍스트 입력
- **🚫 디폴트 값 제거**: 기존 하드코딩된 $ 10,000,000 제거하여 깔끔한 빈 상태 제공
- **📝 자유로운 입력**: Total Amount에 금액뿐만 아니라 협의, TBD 등 다양한 텍스트 입력 가능
- **🎨 시각적 개선**: 편집 가능 영역을 명확히 구분하는 테두리 및 패딩 추가
- **🎯 직관적 UX**: 빈 상태일 때 회색 텍스트로 클릭 가능함을 암시

### 🐛 버그 수정
- **데이터 바인딩**: Total Amount가 실제 coverData.totalAmount 필드와 완전 연동
- **색상 자동 변경**: 데이터 유무에 따라 텍스트 색상 자동 변경 (회색 ↔ 검정)
- **레이아웃 최적화**: Expanded 위젯으로 Total Amount 입력 영역 적절한 공간 할당
- **중앙 정렬**: Total Amount 텍스트 중앙 정렬로 균형 잡힌 레이아웃 구현

### 🎯 사용성 향상
- **완전한 편집 자유도**: 견적서의 모든 요소가 이제 사용자 정의 가능
- **전문적 완성도**: 비즈니스 견적서 표준에 맞는 완전한 편집 환경 제공
- **즉시 반영**: Total Amount 편집 내용이 실시간으로 UI에 반영
- **클린한 시작**: 빈 템플릿에서 시작하여 필요한 내용만 입력하는 효율적 워크플로우

## 📊 앱 성능

### ⚡ 성능 지표
- **앱 크기**: ~24MB (Android AAB)
- **시작 시간**: ~2초
- **메모리 사용량**: ~100MB
- **배터리 효율**: 최적화됨

### 🎯 최적화 기술
- **이미지 압축**: 자동 품질 조정
- **메모리 관리**: 효율적인 이미지 캐싱
- **UI 반응성**: 60fps 유지
- **코드 분할**: 필요시에만 로드

## 🛡️ 보안 및 프라이버시

### 🔒 개인정보 보호
- **로컬 처리**: 모든 사진 편집이 기기 내부에서만 진행
- **데이터 수집 없음**: 개인정보 수집하지 않음
- **네트워크 전송 없음**: 사진이 외부로 전송되지 않음
- **투명성**: 명확한 개인정보처리방침 제공

### 🛡️ 보안 기능
- **앱 샌드박스**: 안전한 실행 환경
- **권한 최소화**: 필수 권한만 요청
- **코드 난독화**: 보안 강화 (릴리스 빌드)

## 🤝 기여하기

### 💡 기여 방법
1. **Fork** 저장소
2. **Feature Branch** 생성 (`git checkout -b feature/amazing-feature`)
3. **Commit** 변경사항 (`git commit -m 'Add some amazing feature'`)
4. **Push** to Branch (`git push origin feature/amazing-feature`)
5. **Pull Request** 생성

### 🐛 버그 리포트
- [GitHub Issues](https://github.com/jagallang/EZPHOTO/issues)를 통해 버그 신고
- 재현 가능한 단계 포함
- 스크린샷 첨부 권장

### 💬 피드백
- Google Play 스토어 리뷰
- GitHub Discussions
- 이메일: [개발자 연락처]

## 📈 로드맵

### 🎯 v1.2.13 (다음 릴리스)
- [ ] 견적서 데이터 영구 저장 기능 (로컬 스토리지/클라우드)
- [ ] 견적서 템플릿 색상 및 폰트 커스터마이징
- [ ] PDF 견적서 자동 생성 및 직접 다운로드 기능
- [ ] 견적서 템플릿 사전 설정 저장/불러오기 시스템

### 🎯 v1.3.0 (예정)
- [ ] 다양한 프레임 템플릿 추가
- [ ] 텍스트 스타일링 옵션 확장
- [ ] 클라우드 저장 기능
- [ ] 소셜 공유 기능

### 🎯 v1.4.0 (장기 계획)
- [ ] 동영상 프레임 지원
- [ ] AI 기반 자동 편집
- [ ] 템플릿 마켓플레이스
- [ ] 데스크톱 앱 (Windows, macOS, Linux)

## 📄 라이선스

이 프로젝트는 [MIT License](LICENSE) 하에 배포됩니다.

## 📞 연락처

- **개발자**: REphoto Team
- **이메일**: [GitHub Issues](https://github.com/jagallang/EZPHOTO/issues)
- **웹사이트**: https://rephoto-88741.web.app
- **GitHub**: https://github.com/jagallang/EZPHOTO

## 🏆 인정사항

### 📚 사용된 오픈소스
- [Flutter](https://flutter.dev) - Google의 UI 툴킷
- [Firebase](https://firebase.google.com) - 웹 호스팅
- [Material Design](https://material.io) - 디자인 시스템

### 🎨 디자인 영감
- 클래식 폴라로이드 카메라
- 빈티지 사진 앨범
- 미니멀 디자인 철학

---

<p align="center">
  <strong>📸 REphoto와 함께 소중한 추억을 더욱 특별하게 만들어보세요! ✨</strong>
</p>

<p align="center">
  <sub>Made with ❤️ by REphoto Team</sub>
</p>