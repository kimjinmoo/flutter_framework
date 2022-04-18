import 'package:app/pages/home/domain/entity/commands_model.dart';
import 'package:app/pages/home/presentation/controllers/home_controller.dart';
import 'package:app/routes/app_pages.dart';
import 'package:app/services/firebase_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

// 홈
class Home extends GetView<HomeController> {

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            color: Color.fromRGBO(0, 0, 0, 0.001),
            child: GestureDetector(
              onTap: () {},
              child: DraggableScrollableSheet(
                initialChildSize: 0.4,
                minChildSize: 0.2,
                maxChildSize: 0.75,
                builder: (BuildContext context, ScrollController scrollController) {
                  return Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                    child: SingleChildScrollView(
                      child: Obx(()=>TextField(
                        controller: controller.commentController,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        textInputAction: TextInputAction.newline,
                        decoration: InputDecoration(
                          hintText: '댓글을 입력하세요',
                          contentPadding: EdgeInsets.all(8.0),
                          suffixIcon: controller.command.value.isEmpty
                              ? null
                              : InkWell(
                            onTap: () => {controller.add(), Navigator.pop(context)},
                            child: const Icon(Icons.app_registration),
                          ),
                        ),
                        autofocus: true,
                        // onSubmitted: (value) {
                        //   print("click!!");
                        //   addCommand();
                        // },
                      )),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(context) {
    // 로또 번호를 생성한다.
    numberMaker() {
      Get.toNamed("${Routes.HOME}${Routes.HOME_MAKER}");
    }
    // Get.put()을 사용하여 클래스를 인스턴스화하여 모든 "child'에서 사용가능하게 합니다.
    final HomeController c = Get.put(HomeController());



    return Scaffold(
      resizeToAvoidBottomInset: false,
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
      body: Column(
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
            onTap: () => {_showBottomSheet(context)},
          ),
          Divider(
            thickness: 0.5,
            color: Theme.of(context).disabledColor,
          ),
          Flexible(
              fit: FlexFit.tight,
              flex: 1,
              child: SingleChildScrollView(
                child: StreamBuilder<QuerySnapshot<CommandsModel>>(
                  stream: getFirebaseInstance(CommandsQuery.createDateDesc, 1),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(snapshot.error.toString()),
                      );
                    }
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final data = snapshot.requireData;

                    return ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: data.size,
                      itemBuilder: (context, index) {
                        return _CommandItem(
                          model: data.docs[index].data(),
                          reference: data.docs[index].reference,
                        );
                      },
                    );
                  },
                ),
              ))
        ],
      ),
    );
  }
}

class _CommandItem extends StatelessWidget {
  _CommandItem({required this.model, required this.reference});

  var show = false;

  final CommandsModel model;
  final DocumentReference<CommandsModel> reference;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          margin: EdgeInsets.zero,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12.0),
              topRight: Radius.circular(12.0),
            ),
          ),
          color: Theme.of(context).cardColor,
          elevation: 0.8,
          child: Container(
            constraints: const BoxConstraints(
              maxHeight: double.infinity,
            ),
            margin: const EdgeInsets.only(right: 16, left: 16),
            child: ListView(
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.only(top: 20),
              shrinkWrap: true,
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: model.userName,
                              style: GoogleFonts.roboto(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Text("3분전"),
                    ],
                  ),
                ),
                Text(
                  model.command,
                  style: GoogleFonts.roboto(
                      fontSize: 14, color: Theme.of(context).disabledColor),
                  textAlign: TextAlign.left,
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 10, top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text.rich(
                        TextSpan(
                          style: Theme.of(context).textTheme.button,
                          children: [
                            WidgetSpan(
                              child: Container(
                                padding: const EdgeInsets.only(right: 2.0),
                                child: const Icon(
                                  Icons.thumb_up,
                                  size: 15.0,
                                  color: Colors.blueAccent,
                                ),
                              ),
                            ),
                            TextSpan(
                                text: model.likeIt.toString(),
                                style: GoogleFonts.roboto(
                                    fontSize: 14, color: Colors.black26)),
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
      ],
    );
  }
}
