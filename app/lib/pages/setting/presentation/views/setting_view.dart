import 'package:lotto/pages/account/presentation/controllers/auth_controller.dart';
import 'package:lotto/pages/setting/presentation/controllers/setting_controller.dart';
import 'package:lotto/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Setting extends GetView<SettingController> {
  @override
  Widget build(BuildContext context) {
    AuthController authController = Get.find();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text("설정", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Container(
        padding: EdgeInsets.only(left: 10, right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 125,
              decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.rectangle
              ),
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Obx(() => Text(
                      authController.userName.value,
                      style: const TextStyle(
                          color: Colors.black54, fontSize: 20),
                    )),
                    IconButton(
                        onPressed: () {
                          Get.toNamed(Routes.ACCOUNT);
                        },
                        icon: const Icon(
                          Icons.settings,
                          color: Colors.black54,
                          size: 20,
                        )),
                  ]),
            ),
            Divider(height: 10),
            Container(
              color: Colors.white,
              child: Column(
                children: [
                  Container(
                    child: TextButton(onPressed: (){
                      Get.toNamed("${Routes.SIDE}${Routes.SIDE_QNA}");
                    }, child: Container(
                      width: double.infinity,
                      child: Row(
                        children: [
                          Text("문의하기", style: TextStyle(color: Colors.black),),
                          Expanded(
                              flex: 1,
                              child: Align(
                                alignment: Alignment.topRight,
                                child: Icon(Icons.chevron_right),
                              )
                          )
                        ],
                      ),
                    )),
                  ),
                  Divider(height: 10),
                  Container(
                    child:
                    TextButton(onPressed: (){
                      Get.toNamed("${Routes.SIDE}${Routes.SIDE_ABOUT}");
                    }, child: Container(
                      width: double.infinity,
                      child: Row(
                        children: [
                          Text("이프로그램은...", style: TextStyle(color: Colors.black)),
                          Expanded(
                              flex: 1,
                              child: Align(
                                alignment: Alignment.topRight,
                                child: Icon(Icons.chevron_right),
                              )
                          )
                        ],
                      ),)),
                  ),
                ],
              ),
            ),
            Divider(height: 10),
            Align(
              alignment: Alignment.topRight,
              child: Text("한방! 로또 추첨기 ${controller.packageInfo.value?.version}"),
            ),
          ],
        ),
      ),
    );
  }
}
