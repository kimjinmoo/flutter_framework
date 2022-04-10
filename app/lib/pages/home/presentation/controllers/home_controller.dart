import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  var count = 0.obs;

  var num1 = 0.obs;
  var num2 = 0.obs;
  var num3 = 0.obs;
  var num4 = 0.obs;
  var num5 = 0.obs;
  var num6 = 0.obs;

  increment() => count++;

  @override
  void onInit() {
    // 스플래시 화면을 종료한다.
    FlutterNativeSplash.remove();
  }
}
