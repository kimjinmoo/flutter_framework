import 'dart:io';

import 'package:app/constants/Environment.dart';
import 'package:app/firebase_options.dart';
import 'package:app/pages/account/presentation/controllers/auth_controller.dart';
import 'package:app/pages/home/presentation/controllers/home_controller.dart';
import 'package:app/pages/home/presentation/controllers/landing_controller.dart';
import 'package:app/pages/maker/presentation/controllers/maker_controller.dart';
import 'package:app/pages/setting/presentation/controllers/setting_controller.dart';
import 'package:app/routes/app_pages.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() async {
  // 계정 초기화
  initialize();
  // 환경 변수를 읽는다.
  await dotenv.load(fileName: Environment.fileName);
  // 엔진과 위젯 바인딩으 완료 되기 전까지 대기
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  // 광고 초기화
  MobileAds.instance.initialize();
  // 스플래시
  // 지연 완료 후 FlutterNativeSplash.remove() 호출
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // 파이어베이스 적용
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // 구글 크래쉬 적용
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  // 웹뷰 초기화
  if(Platform.isAndroid) WebView.platform = AndroidWebView();

  // 스크린 모드를 설정한다.
  // SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  runApp(GetMaterialApp(
    theme: ThemeData(
        appBarTheme: const AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        )
    ),
    darkTheme: ThemeData(
        appBarTheme: const AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        )
    ),
    debugShowCheckedModeBanner: false,
    enableLog: true,
    initialRoute: AppPages.INITIAL,
    getPages: AppPages.routes,
  ));
}

///
/// Get 컨트롤러 주입
///
void initialize() {
  // 컨트롤러 주입
  Get.lazyPut(() => AuthController());
  Get.lazyPut(() => HomeController());
  Get.lazyPut(() => LandingController());
  Get.lazyPut(()=> MakerController());
  Get.lazyPut(() => SettingController());
}

