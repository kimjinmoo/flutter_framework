import 'package:app/constants/Environment.dart';
import 'package:app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() async {
  // 환경 변수를 읽는다.
  await dotenv.load(fileName: Environment.fileName);
  // 지연 완료 후 FlutterNativeSplash.remove() 호출
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

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


