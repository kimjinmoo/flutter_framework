import 'package:flutter/services.dart';
import 'package:lotto/pages/account/presentation/controllers/auth_controller.dart';
import 'package:lotto/pages/home/presentation/controllers/home_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lotto/utils/validation_utils.dart';

class AccountSetting extends GetView<HomeController> {

  TextEditingController inputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find();

    return Obx(()=>Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.black),
          title: const Text("닉네임 설정", style: TextStyle(color: Colors.black)),
          backgroundColor: Colors.transparent,
          elevation: 0.0
        ),
        body: SafeArea(
            child: Padding(
              padding: EdgeInsets.only(left: 15, right: 15),
              child: Column(
                crossAxisAlignment : CrossAxisAlignment.start,
                children: [
                  Text("닉네임", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                  TextField(
                    maxLength: 15,
                    controller: inputController,
                    decoration: InputDecoration(
                      labelText: authController.userName.value,
                    ),
                  ),
                  Divider(),
                  Text("앱 내부에서 사용되는 닉네임입니다.\n별도의 개인정보는 수집하지 않습니다.", style: TextStyle(fontSize: 13),),
                ],
              ),
            )),
      bottomNavigationBar: Obx(() => Padding(
        padding: EdgeInsets.only(left: 10, right: 10, bottom: 20),
        child: OutlinedButton.icon(
            onPressed: (controller.isProgress.value)
                ? null
                : () async => {
                  if(inputController.text.length > 0) {
                    if(!isBlackListCheck(inputController.text)) {
                      await authController.changeUserName(inputController.text),
                      Get.back()
                    } else {
                      HapticFeedback.heavyImpact(),
                      Get.snackbar("경고", "사용할수 없는 단어가 포함되어 있습니다.")
                    }
                  } else {
                    Get.snackbar("경고", "최소한 한글자 이상 입력하세요.")
                  }
                },
            style: ButtonStyle(
              backgroundColor:
              MaterialStateProperty.all(Colors.deepPurple),
            ),
            icon: (controller.isProgress.value)
                ? SizedBox(
              child: const CircularProgressIndicator(),
              height: 22,
              width: 22,
            )
                : const Icon(
              Icons.done,
              color: Colors.white,
              size: 25,
            ),
            label: const Text(
              "변경",
              style: TextStyle(color: Colors.white),
            )),
      )),
    ));
  }


}
