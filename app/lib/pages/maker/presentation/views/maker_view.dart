import 'package:app/pages/home/presentation/controllers/home_controller.dart';
import 'package:app/pages/maker/presentation/controllers/maker_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

///
/// 로또번호를 생성한다.
///
class Maker extends GetView<MakerController> {
  @override
  Widget build(BuildContext context) {
    HomeController homeController = Get.find();
    // 로또번호
    final lottoNumber = <Widget>[];
    // 구매카운트
    final buyCount = <Widget>[];

    // 로또 번호 widget 생성
    for (var i = 1; i < 46; i++) {
      lottoNumber.add(Obx(() => lottoNumberCheckbox(
          MediaQuery.of(context).size.width,
          i,
          () => controller.onTapNumber(i),
          controller.number.value.contains(i))));
    }
    // 구매 카운트
    for (var i = 1; i < 6; i++) {
      buyCount.add(Obx(() => lottoNumberCheckbox(
          MediaQuery.of(context).size.width,
          i,
          () => controller.onChangeCount(i),
          controller.count.value == i)));
    }

    // 번호 뽑기 로직 링크
    final Uri _url = Uri.parse('https://www.grepiu.com/toy/lotto/ai?offNav=off');

    // 스넥바 성공메세지
    final sucessMsg = SnackBar(
      backgroundColor: Colors.red,
      content: const Text('번호가 생성되였습니다.')
    );

    return GetBuilder<MakerController>(
      builder: (controller) => Scaffold(
          appBar: AppBar(
            centerTitle: true,
            iconTheme: const IconThemeData(color: Colors.black),
            title:
                const Text("AI 번호 생성기", style: TextStyle(color: Colors.black)),
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            actions: [
              PopupMenuButton(
                icon: Icon(Icons.more_vert),
                  itemBuilder: (_) => [
                    PopupMenuItem<int>(
                      value: 0,
                      child: Text("번호생성 안내",style: TextStyle(color: Colors.black),),
                    ),
                  ],
                  onSelected: (item) async {
                    switch(item){
                      case 0:
                          if(!await launchUrl(_url)) throw '실행할수 없는 URL 입니다.';
                        break;
                    }
                  },
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 15, right: 15, bottom: 7),
                  child: Obx(()=>Row(
                    children: [
                      Text(
                        "선택 - ${controller.getMode()}",
                        style: TextStyle(
                            color: Colors.black54,
                            fontSize: 17,
                            fontWeight: FontWeight.bold),
                      ),
                      controller.getValues().length > 0?
                      Expanded(
                          child: Align(
                              alignment: Alignment.topRight,
                              child: InkWell(
                                  child: Icon(Icons.clear, size: 20,),
                                  onTap: ()=>controller.clear(),
                              )
                          )
                      )
                          :SizedBox()
                    ],
                  )),
                ),
                Container(
                  margin: EdgeInsets.only(left: 15, right: 15),
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black, width: 1),
                  ),
                  alignment: Alignment.center,
                  child: Wrap(
                    runSpacing: 5.0,
                    alignment: WrapAlignment.center,
                    spacing: 5.0,
                    children: lottoNumber,
                  ),
                ),
                const Padding(
                  padding:
                      EdgeInsets.only(top: 7, left: 15, right: 15, bottom: 7),
                  child: Text(
                    "구매 횟수",
                    style: TextStyle(
                        color: Colors.black54,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  child: Wrap(
                    runSpacing: 5.0,
                    alignment: WrapAlignment.center,
                    spacing: 5.0,
                    children: buyCount,
                  ),
                )
              ],
            ),
          ),
          bottomNavigationBar: Obx(() => Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: OutlinedButton.icon(
                    onPressed: (controller.isProcess.value ||
                            homeController.isProgress.value)
                        ? null
                        : () async => {
                              // 현재 회차 조회
                              await homeController.fetchCurrentRoundInit(),
                              // 등록
                              await controller
                                  .createNumbers(
                                      homeController.nextRound.value,
                                      controller.getValues(),
                                      controller.count.value)
                                  .onError((error, stackTrace) => Get.snackbar(
                                        "에러",
                                        error.toString(),
                                        snackPosition: SnackPosition.BOTTOM,
                                      )),
                              // 현재 회차 조회
                              await homeController
                                  .setRound(homeController.nextRound.value),
                              ScaffoldMessenger.of(context).showSnackBar(sucessMsg)
                            },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.deepPurple),
                      // fixedSize: MaterialStateProperty.resolveWith((states) => const Size(65.0, 65.0),),
                    ),
                    icon: (controller.isProcess.value ||
                            homeController.isProgress.value)
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
                      "번호 생성",
                      style: TextStyle(color: Colors.white),
                    )),
              ))),
    );
  }

  Widget lottoNumberCheckbox(
      double width, int number, Function onTap, bool isChecked) {
    return InkWell(
      onTap: () => onTap(),
      child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              top: BorderSide(
                ////               <--- left side
                color: Color.fromRGBO(248, 57, 49, 1),
                style: BorderStyle.solid,
                width: 3.0,
              ),
              bottom: BorderSide(
                //                   <--- left side
                color: Color.fromRGBO(248, 57, 49, 1),
                style: BorderStyle.solid,
                width: 3.0,
              ),
            ),
          ),
          height: width / 11.5,
          width: width / 6.5,
          child: Stack(
            children: [
              Center(
                child: Text("${number}",
                    style: TextStyle(color: Colors.black, fontSize: 18)),
              ),
              isChecked
                  ? Center(
                      child: Icon(Icons.check,
                          size: width / 11.5,
                          color: Color.fromRGBO(248, 57, 49, 1)),
                    )
                  : SizedBox()
            ],
          )),
    );
  }
}