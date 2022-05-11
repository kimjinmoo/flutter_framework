import 'package:app/pages/home/presentation/controllers/home_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class Setting extends GetView<HomeController> {

  TextEditingController inputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Obx(()=>Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.black),
          title: const Text("설정", style: TextStyle(color: Colors.black)),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          actions: [
            controller.isProgress.value?CircularProgressIndicator():
            IconButton(onPressed: () async {
              if(inputController.text.length > 0) {
                await controller.changeUserName(inputController.text);
                Get.back();
              } else {
                Get.snackbar("경고", "최소한 한글자 이상 입력하세요.");
              }
            }, icon: Icon(Icons.done, color: Colors.red))
          ],
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
                      labelText: controller.userName.value,
                    ),
                  )
                ],
              ),
            ))));
  }
}
