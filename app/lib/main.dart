import 'package:app/constants/Environment.dart';
import 'package:app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  // 환경 변수를 읽는다.
  await dotenv.load(fileName: Environment.fileName);
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
          systemOverlayStyle: SystemUiOverlayStyle.light,
        )
    ),
    debugShowCheckedModeBanner: false,
    enableLog: true,
    initialRoute: AppPages.INITIAL,
    getPages: AppPages.routes,
  ));
}
