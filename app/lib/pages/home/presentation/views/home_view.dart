import 'package:app/pages/home/presentation/controllers/home_controller.dart';
import 'package:app/routes/app_pages.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

// 홈
class Home extends GetView<HomeController> {
  var show = false;

  @override
  Widget build(context) {
    // Get.put()을 사용하여 클래스를 인스턴스화하여 모든 "child'에서 사용가능하게 합니다.
    final HomeController c = Get.put(HomeController());
    // 로또 번호를 생성한다.
    numberMaker() {
      Get.toNamed("${Routes.HOME}${Routes.HOME_MAKER}");
    }

    return Scaffold(
      resizeToAvoidBottomInset : false,
      // count가 변경 될 때마다 Obx(()=> 를 사용하여 Text()에 업데이트합니다.
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        title:
            const Text("AI Lotte 추첨기", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                  onPressed: () {
                    Get.toNamed("${Routes.HOME}${Routes.HOME_QRCODE}");
                  },
                  icon: const FaIcon(FontAwesomeIcons.qrcode))
            ],
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            ListTile(
              title: const Text('로또 히스토리'),
              onTap: () {
                Get.toNamed("${Routes.SIDE}${Routes.SIDE_HISTORY}");
              },
            ),
            ListTile(
              title: const Text('이프로그램은....'),
              onTap: () {
                Get.toNamed("${Routes.SIDE}${Routes.SIDE_ABOUT}");
              },
            ),
          ],
        ),
      ),
      // 8줄의 Navigator.push를 간단한 Get.to()로 변경합니다. context는 필요없습니다.
      body: SingleChildScrollView(
          padding: EdgeInsets.only(left: 10, right: 10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("내 로또번호"),
                  IconButton(
                      onPressed: () {
                        Get.toNamed("${Routes.HOME}${Routes.HOME_WEEK}");
                      },
                      icon: const FaIcon(
                        FontAwesomeIcons.rectangleList,
                        size: 15,
                      ))
                ],
              ),
              Container(
                alignment: Alignment.center,
                child: const Text("00 00 00 00 00 00",
                    style: TextStyle(fontSize: 20)),
              ),
              const Padding(padding: EdgeInsets.only(bottom: 10, top: 10)),
              Container(
                alignment: Alignment.topLeft,
                child: const Text("1050회차 당첨번호"),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                      onPressed: () {},
                      icon: const FaIcon(FontAwesomeIcons.angleLeft)),
                  Container(
                    alignment: Alignment.center,
                    child: const Text(
                      "00 00 00 00 00 00",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    height: 40,
                  ),
                  IconButton(
                      onPressed: () {},
                      icon: const FaIcon(FontAwesomeIcons.angleRight))
                ],
              ),
              Container(
                alignment: Alignment.topRight,
                child: const Text("지난회차 번호"),
              ),
              ElevatedButton(
                onPressed: numberMaker,
                child: const Text("AI 번호 생성"),
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(40)),
              ),
              const SizedBox(
                height: 10,
              ),
              InkWell(
                child: Text(
                  "댓글 남기기",
                  style: GoogleFonts.roboto(
                    fontSize: 16,
                    color: Theme.of(context).disabledColor,
                  ),
                ),
                onTap: () => print('오호~'),
              ),
              Divider(
                thickness: 0.5,
                color: Theme.of(context).disabledColor,
              ),
              SizedBox(
                height: 10,
              ),
              //list comments
              Card(
                margin: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12.0),
                    topRight: Radius.circular(12.0),
                  ),
                ),
                color: Theme.of(context).cardColor,
                elevation: 0.8,
                child: Container(
                  constraints: BoxConstraints(
                    maxHeight: double.infinity,
                  ),
                  margin: EdgeInsets.only(right: 16, left: 16),
                  child: ListView(
                    padding: EdgeInsets.only(top: 20),
                    shrinkWrap: true,
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: "진무",
                                    style: GoogleFonts.roboto(
                                        fontSize: 16,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              "3분전"
                            ),
                          ],
                        ),
                      ),
                      Text(
                        "대박이다 1등 담청!!!",
                        style: GoogleFonts.roboto(
                            fontSize: 14,
                            color: Theme.of(context).disabledColor),
                        textAlign: TextAlign.left,
                      ),
                      Container(
                        margin: const EdgeInsets.only(bottom: 10, top: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              child: Text('6 댓글',
                                  style: GoogleFonts.roboto(
                                      fontSize: 12,
                                      color: show
                                          ? Colors.blue
                                          : Theme.of(context).disabledColor)),
                              onTap: () {},
                            ),
                            Text.rich(
                              TextSpan(
                                style: Theme.of(context).textTheme.button,
                                children: [
                                  WidgetSpan(
                                    child: Container(
                                      padding: EdgeInsets.only(right: 2.0),
                                      child: Icon(
                                        Icons.thumb_down,
                                        size: 15.0,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                  TextSpan(
                                      text: "3",
                                      style: GoogleFonts.roboto(
                                          fontSize: 14, color: Colors.red)),
                                ],
                              ),
                            ),
                            Text.rich(
                              TextSpan(
                                style: Theme.of(context).textTheme.button,
                                children: [
                                  WidgetSpan(
                                    child: Container(
                                      padding: EdgeInsets.only(right: 2.0),
                                      child: Icon(
                                        Icons.thumb_up,
                                        size: 15.0,
                                        color: Theme.of(context).buttonColor,
                                      ),
                                    ),
                                  ),
                                  TextSpan(
                                      text: "3",
                                      style: GoogleFonts.roboto(
                                          fontSize: 14,
                                          color:
                                              Theme.of(context).buttonColor)),
                                ],
                              ),
                            ),
                            Text.rich(
                              TextSpan(
                                style: Theme.of(context).textTheme.button,
                                children: [
                                  WidgetSpan(
                                    child: Container(
                                      padding: EdgeInsets.only(right: 2.0),
                                      child: Icon(
                                        Icons.reply,
                                        size: 15.0,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ),
                                  TextSpan(
                                      text: "댓글",
                                      style: GoogleFonts.roboto(
                                          fontSize: 14, color: Colors.blue)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Divider(
                thickness: 0.5,
                color: Theme.of(context).disabledColor,
              ),
              Card(
                margin: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12.0),
                    topRight: Radius.circular(12.0),
                  ),
                ),
                color: Theme.of(context).cardColor,
                elevation: 0.8,
                child: Container(
                  constraints: BoxConstraints(
                    maxHeight: double.infinity,
                  ),
                  margin: EdgeInsets.only(right: 16, left: 16),
                  child: ListView(
                    padding: EdgeInsets.only(top: 20),
                    shrinkWrap: true,
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: "진무",
                                    style: GoogleFonts.roboto(
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                                "3분전"
                            ),
                          ],
                        ),
                      ),
                      Text(
                        "대박이다 3등 담청!!!",
                        style: GoogleFonts.roboto(
                            fontSize: 14,
                            color: Theme.of(context).disabledColor),
                        textAlign: TextAlign.left,
                      ),
                      Container(
                        margin: const EdgeInsets.only(bottom: 10, top: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              child: Text('6 댓글',
                                  style: GoogleFonts.roboto(
                                      fontSize: 12,
                                      color: show
                                          ? Colors.blue
                                          : Theme.of(context).disabledColor)),
                              onTap: () {},
                            ),
                            Text.rich(
                              TextSpan(
                                style: Theme.of(context).textTheme.button,
                                children: [
                                  WidgetSpan(
                                    child: Container(
                                      padding: EdgeInsets.only(right: 2.0),
                                      child: Icon(
                                        Icons.thumb_down,
                                        size: 15.0,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                  TextSpan(
                                      text: "3",
                                      style: GoogleFonts.roboto(
                                          fontSize: 14, color: Colors.red)),
                                ],
                              ),
                            ),
                            Text.rich(
                              TextSpan(
                                style: Theme.of(context).textTheme.button,
                                children: [
                                  WidgetSpan(
                                    child: Container(
                                      padding: EdgeInsets.only(right: 2.0),
                                      child: Icon(
                                        Icons.thumb_up,
                                        size: 15.0,
                                        color: Theme.of(context).buttonColor,
                                      ),
                                    ),
                                  ),
                                  TextSpan(
                                      text: "3",
                                      style: GoogleFonts.roboto(
                                          fontSize: 14,
                                          color:
                                          Theme.of(context).buttonColor)),
                                ],
                              ),
                            ),
                            Text.rich(
                              TextSpan(
                                style: Theme.of(context).textTheme.button,
                                children: [
                                  WidgetSpan(
                                    child: Container(
                                      padding: EdgeInsets.only(right: 2.0),
                                      child: Icon(
                                        Icons.reply,
                                        size: 15.0,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ),
                                  TextSpan(
                                      text: "댓글",
                                      style: GoogleFonts.roboto(
                                          fontSize: 14, color: Colors.blue)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Divider(
                thickness: 0.5,
                color: Theme.of(context).disabledColor,
              ),
              Card(
                margin: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12.0),
                    topRight: Radius.circular(12.0),
                  ),
                ),
                color: Theme.of(context).cardColor,
                elevation: 0.8,
                child: Container(
                  constraints: BoxConstraints(
                    maxHeight: double.infinity,
                  ),
                  margin: EdgeInsets.only(right: 16, left: 16),
                  child: ListView(
                    padding: EdgeInsets.only(top: 20),
                    shrinkWrap: true,
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: "진무",
                                    style: GoogleFonts.roboto(
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                                "3분전"
                            ),
                          ],
                        ),
                      ),
                      Text(
                        "대박이다 2등 담청!!!",
                        style: GoogleFonts.roboto(
                            fontSize: 14,
                            color: Theme.of(context).disabledColor),
                        textAlign: TextAlign.left,
                      ),
                      Container(
                        margin: const EdgeInsets.only(bottom: 10, top: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              child: Text('6 댓글',
                                  style: GoogleFonts.roboto(
                                      fontSize: 12,
                                      color: show
                                          ? Colors.blue
                                          : Theme.of(context).disabledColor)),
                              onTap: () {},
                            ),
                            Text.rich(
                              TextSpan(
                                style: Theme.of(context).textTheme.button,
                                children: [
                                  WidgetSpan(
                                    child: Container(
                                      padding: EdgeInsets.only(right: 2.0),
                                      child: Icon(
                                        Icons.thumb_down,
                                        size: 15.0,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                  TextSpan(
                                      text: "3",
                                      style: GoogleFonts.roboto(
                                          fontSize: 14, color: Colors.red)),
                                ],
                              ),
                            ),
                            Text.rich(
                              TextSpan(
                                style: Theme.of(context).textTheme.button,
                                children: [
                                  WidgetSpan(
                                    child: Container(
                                      padding: EdgeInsets.only(right: 2.0),
                                      child: Icon(
                                        Icons.thumb_up,
                                        size: 15.0,
                                        color: Theme.of(context).buttonColor,
                                      ),
                                    ),
                                  ),
                                  TextSpan(
                                      text: "3",
                                      style: GoogleFonts.roboto(
                                          fontSize: 14,
                                          color:
                                          Theme.of(context).buttonColor)),
                                ],
                              ),
                            ),
                            Text.rich(
                              TextSpan(
                                style: Theme.of(context).textTheme.button,
                                children: [
                                  WidgetSpan(
                                    child: Container(
                                      padding: EdgeInsets.only(right: 2.0),
                                      child: Icon(
                                        Icons.reply,
                                        size: 15.0,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ),
                                  TextSpan(
                                      text: "댓글",
                                      style: GoogleFonts.roboto(
                                          fontSize: 14, color: Colors.blue)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          )),
    );
  }
}
