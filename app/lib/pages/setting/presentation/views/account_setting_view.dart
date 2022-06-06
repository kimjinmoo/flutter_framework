import 'package:app/pages/account/presentation/controllers/auth_controller.dart';
import 'package:app/pages/home/presentation/controllers/home_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
          title: const Text("설정", style: TextStyle(color: Colors.black)),
          backgroundColor: Colors.transparent,
          elevation: 0.0
        ),
        body: SafeArea(
            child: Padding(
              padding: EdgeInsets.only(left: 15, right: 15),
              child: Column(
                crossAxisAlignment : CrossAxisAlignment.start,
                children: [
                  Text("유저명", style: TextStyle(fontSize: 20),),
                  TextField(
                    maxLength: 15,
                    controller: inputController,
                    decoration: InputDecoration(
                      labelText: authController.userName.value,
                    ),
                  )
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
                    await authController.changeUserName(inputController.text),
                    Get.back()
                  } else {
                    Get.snackbar("경고", "최소한 한글자 이상 입력하세요.")
                  }
                },
            style: ButtonStyle(
              backgroundColor:
              MaterialStateProperty.all(Colors.deepPurple),
              // fixedSize: MaterialStateProperty.resolveWith((states) => const Size(65.0, 65.0),),
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
