import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

///
/// 설정 정보 컨트롤러
///
class SettingController extends GetxController {

  // 패키지
  Rxn<PackageInfo> packageInfo = Rxn();

  @override
  void onInit() async {
    super.onInit();
    // 패키지명
    packageInfo.value = await PackageInfo.fromPlatform();
  }
}
