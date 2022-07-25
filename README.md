#flutter 구조 잡기

##flutter_native_splash

flutter_native_splash.yaml 설정적용 후 아래 코맨트 입력  
1.pubspec.yaml 에 flutter native 추가
>dependencies:  
>flutter_native_splash: ^2.2.3+1  
2. root에 flutter_native_splash.yaml 파일 생성
>flutter_native_splash:  
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;color: "#42a5f5"    
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;android_12:  
3. flutter pub run flutter_native_splash:create 실행  
`flutter pub run flutter_native_splash:create`
4. main.dart에 제어 추가  
>#로딩 시작  
>WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();  
>FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);  
#로딩이 끝나면  
> FlutterNativeSplash.remove();

옵션  
설정`flutter pub run flutter_native_splash:create`  
삭제 `flutter pub run flutter_native_splash:remove`  

##getx  
https://pub.dev/packages/get  





