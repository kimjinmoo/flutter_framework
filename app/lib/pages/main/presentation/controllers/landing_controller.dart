import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';

///
/// 랜딩페이지
///
class LandingController extends GetxController {
  var tabIndex = 0.obs;

  int maxFailedLoadAttempts = 3;

  void changeTabIndex(int index) {
    tabIndex.value = index;
  }

  @override
  void onInit() async {
    super.onInit();
    // 렌딩 페에지가 뜨면 스플래시 화면을 종료한다.
    FlutterNativeSplash.remove();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
