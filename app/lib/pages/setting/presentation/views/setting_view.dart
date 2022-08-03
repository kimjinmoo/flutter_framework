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
  // 다이얼로그
  _showSimpleModalDialog(context, AuthController authController){
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
                borderRadius:BorderRadius.circular(20.0)),
            content: Container(
              constraints: BoxConstraints(maxHeight: 145),
              width: 300,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(padding: EdgeInsets.only(top: 15, bottom: 5), child: Text("서비스 이용동의", style: TextStyle(fontWeight: FontWeight.bold),),),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(child: Row(
                        children: [
                          Checkbox(value: true, onChanged: (state){}),
                          Text("이용약관 동의(필수)"),
                        ],
                      )),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0,0,15.0,0),
                        child: Align(
                            alignment: Alignment.centerRight,
                            child: InkWell(
                              onTap: () async {
                                // 번호 뽑기 로직 링크
                                if (!await launchUrl(Uri.parse(
                                    'https://data.grepiu.com/lotto/lotto_terms.html')))
                                  throw '실행할수 없는 URL 입니다.';
                              },
                             child: Text(">"),
                            )
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(child: Row(
                        children: [
                          Checkbox(value: true, onChanged: (state){
                          }),
                          Text("개인정보 수집 이용 동의(필수)"),
                        ],
                      )),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0,0,15.0,0),
                        child: Align(
                            alignment: Alignment.centerRight,
                            child: InkWell(
                              onTap: () async {
                                // 번호 뽑기 로직 링크
                                if (!await launchUrl(Uri.parse(
                                    'https://data.grepiu.com/lotto/lotto_privacy.html')))
                                  throw '실행할수 없는 URL 입니다.';
                              },
                              child: Text(">"),
                            )
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              ElevatedButton(
                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.black26),),
                  onPressed: (){
                    Get.back();
                  },
                  child: Text("취소")),
              ElevatedButton(
                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.deepPurple),),
                  onPressed: () async {
                    await authController.agreementPolicyByUser();
                    Get.back();
                  },
                  child: Text("확인"))
            ],
          );
        });
  }

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
            Obx(()=>Container(
                decoration: BoxDecoration(color: Colors.white),
                padding: EdgeInsets.only(top: 10),
                height: 125,
                child: Column(
                  children: [
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            authController.userName.value,
                            style: const TextStyle(
                                color: Colors.black54, fontSize: 20),
                          ),
                          IconButton(
                              onPressed: () {
                                if(authController.user.value.privacyAgreementYn == 'Y') {
                                  Get.toNamed(Routes.ACCOUNT);
                                } else {
                                  _showSimpleModalDialog(context, authController);
                                }

                              },
                              icon: authController.user.value.privacyAgreementYn == 'Y'?const Icon(
                                Icons.settings,
                                color: Colors.pink,
                                size: 20,
                              ):const Icon(
                                Icons.lock,
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
                ))),
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
