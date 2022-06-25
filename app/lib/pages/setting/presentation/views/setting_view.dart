import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lotto/pages/account/domain/entity/user_model.dart';
import 'package:lotto/pages/account/presentation/controllers/auth_controller.dart';
import 'package:lotto/pages/setting/presentation/controllers/setting_controller.dart';
import 'package:lotto/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lotto/services/firebase_service.dart';
import 'package:url_launcher/url_launcher.dart';

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
                decoration: BoxDecoration(color: Colors.white),
                padding: EdgeInsets.only(top: 10),
                height: 125,
                child: Column(
                  children: [
                    Row(
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
                                color: Colors.pink,
                                size: 20,
                              )),
                        ]),
                    Text.rich(TextSpan(children: [
                      WidgetSpan(
                          child: Container(
                        padding: EdgeInsets.only(right: 5),
                        child: FaIcon(
                          FontAwesomeIcons.crown,
                          size: 18,
                          color: Colors.orange,
                        ),
                      )),
                      TextSpan(
                          text: authController.user.value.maxRank == 0
                              ? "당첨 경험 없음"
                              : "${authController.user.value.maxRank}등 경험자",
                          style: TextStyle(color: Colors.black54))
                    ]))
                  ],
                )),
            Divider(height: 10),
            Container(
              color: Colors.white,
              child: Column(
                children: [
                  Container(
                    child: TextButton(
                        onPressed: () {
                          Get.toNamed(Routes.SIDE_QNA);
                        },
                        child: Container(
                          width: double.infinity,
                          child: Row(
                            children: [
                              Text(
                                "문의하기",
                                style: TextStyle(color: Colors.black),
                              ),
                              Expanded(
                                  flex: 1,
                                  child: Align(
                                    alignment: Alignment.topRight,
                                    child: Icon(Icons.chevron_right),
                                  ))
                            ],
                          ),
                        )),
                  ),
                  Divider(height: 10),
                  Container(
                    child: TextButton(
                        onPressed: () async {
                          // 번호 뽑기 로직 링크
                          if (!await launchUrl(Uri.parse(
                              'https://www.grepiu.com/toy/lotto/about?offNav=off')))
                            throw '실행할수 없는 URL 입니다.';
                        },
                        child: Container(
                          width: double.infinity,
                          child: Row(
                            children: [
                              Text("Opensource License",
                                  style: TextStyle(color: Colors.black)),
                              Expanded(
                                  flex: 1,
                                  child: Align(
                                    alignment: Alignment.topRight,
                                    child: Icon(Icons.chevron_right),
                                  ))
                            ],
                          ),
                        )),
                  ),
                ],
              ),
            ),
            Divider(height: 10),
            Align(
              alignment: Alignment.topRight,
              child:
                  Text("한방! 로또 추첨기 ${controller.packageInfo.value?.version}"),
            ),
          ],
        ),
      ),
    );
  }
}
