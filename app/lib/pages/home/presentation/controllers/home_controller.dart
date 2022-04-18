import 'package:app/services/firebase_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final commentFormKey = GlobalKey<FormState>();
  final commentController = TextEditingController();

  var command = "".obs;


  clear() => commentController.clear();

  @override
  void onInit() {
    // 스플래시 화면을 종료한다.
    FlutterNativeSplash.remove();
    // text 업데이트
    commentController.addListener(() {
      command.value = commentController.text;
    });
    super.onInit();
  }

  @override
  void onClose() {
    commentController.dispose();
    super.onClose();
  }

  void add() {
    addCommand(
      1,
      commentController.text
    ).then((res){
      Get.snackbar('결과', "입력되었습니다.");
      clear();
    });
  }
}
