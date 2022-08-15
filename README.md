# flutter 구조 잡기

최초 설정 참조(https://flutter-ko.dev/docs/get-started/install/macos)

기본 구조
```yaml
constants 상수
lang 언어
pages 페이지 
  path 
     domain
     presentation
        controllers  getx 컨트롤러
        views        getx view
routers getx router
service http api 
ui 공통 턴퍼넌트
utils 공통 유틸
```

#### 1. app 생성

```flutter create my_app```


#### 2. subspec.yaml에 의존성 추가

dependencies
```
cupertino_icons: ^1.0.5
get: ^4.6.5
font_awesome_flutter: ^10.1.0
shared_preferences: ^2.0.15
google_fonts: ^3.0.1
cached_network_image: ^3.2.1
http: ^0.13.4
flutter_dotenv: ^5.0.2
badges: ^2.0.3
uuid: ^3.0.6
timeago: ^3.2.2
webview_flutter: ^3.0.4
intl: ^0.17.0
shimmer: ^2.0.0
url_launcher: ^6.1.5
package_info_plus: ^1.4.3
numberpicker: ^2.1.1
```

#### 3. 환경변수 적용
env 복사  
.env.development  
.env.production

pubspec.yaml 추가  

```yaml
flutter:
assets:
- .env.development
- .env.production
```


#### 4. 옵션 선택

### flutter_native_splash

```flutter pub add flutter_native_splash```

#### root에 flutter_native_splash.yaml 파일 생성 및 코드 추가

```yaml
flutter_native_splash:
  color: "#42a5f5"
  android_12:
```
  
#### flutter pub run flutter_native_splash:create 실행

```
flutter pub run flutter_native_splash:create
```
#### main.dart에 제어 추가

로딩 시작 
```  
WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();  
FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
```  
로딩이 끝나면
```
FlutterNativeSplash.remove();
```

#### 옵션  
설정`flutter pub run flutter_native_splash:create`  
삭제 `flutter pub run flutter_native_splash:remove`  

### firebase  
https://pub.dev/packages/get

https://firebase.google.com/docs/flutter/setup?hl=ko&platform=ios

#### 적용
```
firebase login
dart pub global activate flutterfire_cli
# firebase 프로젝트 추가
flutterfire configure
flutter pub add firebase_core
#확인
flutterfire configure
#podfile 2번라인 주석제거
platform :ios, '9.0'
```

### 광고

```yaml
google_mobile_ads: ^2.0.1
```






