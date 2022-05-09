import 'package:app/pages/home/domain/entity/commands_model.dart';
import 'package:app/pages/home/presentation/controllers/home_controller.dart';
import 'package:app/routes/app_pages.dart';
import 'package:app/services/firebase_service.dart';
import 'package:app/utils/time_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:badges/badges.dart';

// 홈
class Home extends GetView<HomeController> {

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        double keyboardHeight = MediaQuery.of(context).viewInsets.bottom / 1000;
        return GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            color: Color.fromRGBO(0, 0, 0, 0.001),
            child: GestureDetector(
                onTap: () {},
                child: Obx(
                  () => DraggableScrollableSheet(
                    initialChildSize: keyboardHeight +
                        0.20 +
                        (controller.getCommentLine() * 0.01),
                    minChildSize: keyboardHeight +
                        0.20 +
                        (controller.getCommentLine() * 0.01),
                    maxChildSize: keyboardHeight + 0.40,
                    builder: (BuildContext context,
                        ScrollController scrollController) {
                      return Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                        ),
                        child: SingleChildScrollView(
                          child: TextField(
                            controller: controller.commentController,
                            keyboardType: TextInputType.multiline,
                            maxLines: 3,
                            textInputAction: TextInputAction.newline,
                            decoration: InputDecoration(
                              hintText: '댓글을 입력하세요',
                              contentPadding: EdgeInsets.all(8.0),
                              suffixIcon: controller.comment.value.isEmpty
                                  ? null
                                  : InkWell(
                                      onTap: () => {
                                        controller.addComment(),
                                        Navigator.pop(context)
                                      },
                                      child: const Icon(Icons.app_registration),
                                    ),
                            ),
                            autofocus: true,
                            // onSubmitted: (value) {
                            //   print("click!!");
                            //   addCommand();
                            // },
                          ),
                        ),
                      );
                    },
                  ),
                )),
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
          centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text("ㅈㅈㄱㄹㄷ", style: TextStyle(color: Colors.black))
            ,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              child: Stack(
                children: [
                  Positioned(
                    bottom: 8.0,
                    left: 4.0,
                    child: Obx(() => Text(
                          controller.userName.value,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 20),
                        )),
                  )
                ],
              ),
              decoration: const BoxDecoration(
                color: Colors.red,
              ),
            ),
            ListTile(
              title: const Text('당첨 통계'),
              onTap: () {
                Get.toNamed("${Routes.SIDE}${Routes.SIDE_STATUS}");
              },
            ),
            ListTile(
              title: const Text('문의하기'),
              onTap: () {
                Get.toNamed("${Routes.SIDE}${Routes.SIDE_QNA}");
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
                  icon: Obx(() => Badge(
                      animationType: BadgeAnimationType.slide,
                      badgeColor: Colors.black,
                      showBadge:
                          controller.myLotteHistory.value.numbers.length > 1,
                      alignment: Alignment.bottomRight,
                      badgeContent: Text(
                          "${controller.myLotteHistory.value.numbers.length}",
                          style: TextStyle(color: Colors.white70)),
                      child: const FaIcon(
                        FontAwesomeIcons.rectangleList,
                        size: 24,
                      ))))
            ],
          ),
          Obx(() => Text(controller.firstNumber.value,
              style: TextStyle(fontSize: 20))),
          const Padding(padding: EdgeInsets.only(bottom: 10, top: 10)),
          Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.only(left: 15),
            child: Obx(() => Text("${controller.round.value} 회차 당첨번호")),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Obx(() => IconButton(
                  onPressed: controller.isProgress.value
                      ? null
                      : () {
                          controller.beforeRound();
                        },
                  icon: const FaIcon(FontAwesomeIcons.angleLeft))),
              Expanded(
                  flex: 1,
                  child: Container(
                    alignment: Alignment.center,
                    child: Obx(() => controller.isProgress.value
                        ? const Text('읽는중')
                        : Text(
                            controller.roundWinningNumber.value,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black54,
                                fontSize: 21),
                          )),
                    height: 40,
                  )),
              Obx(() => IconButton(
                  onPressed: controller.isProgress.value
                      ? null
                      : () {
                          controller.nextRound();
                        },
                  icon: const FaIcon(FontAwesomeIcons.angleRight)))
            ],
          ),
          Padding(
              padding: EdgeInsets.only(left: 10, right: 10),
            child: ElevatedButton(
              onPressed: numberMaker,
              child: const Text("AI 번호 생성", style: TextStyle(color: Colors.black87),),
              style: ElevatedButton.styleFrom(
                textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                // We can change style of this beautiful elevated button thanks to style prop
                minimumSize: const Size.fromHeight(40),
                primary: Colors.white, // we can set primary color
                onPrimary: Colors.white, // change color of child prop
                onSurface: Colors.blue, // surface color
                shadowColor: Colors.grey, //shadow prop is a very nice prop for every button or card widgets.
                elevation: 1, // we can set elevation of this beautiful button
                side: BorderSide(
                    color: Colors.black, //change border color
                    width: 2, //change border width
                    style: BorderStyle.solid), // change border side of this beautiful button
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      10), //change border radius of this beautiful button thanks to BorderRadius.circular function
                ),
                tapTargetSize: MaterialTapTargetSize.padded,
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          InkWell(
            child: Container(
              width: double.infinity,
              child: Center(
                child: Text(
                  "댓글 남기기",
                  style: GoogleFonts.roboto(
                    fontSize: 16,
                    color: Theme.of(context).disabledColor,
                  ),
                ),
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
              child: Obx(() => SingleChildScrollView(
                    child: StreamBuilder<QuerySnapshot<CommandsModel>>(
                      stream: getFirebaseInstance(
                          CommandsQuery.createDateDesc, controller.round.value),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Center(
                            child: Text(snapshot.error.toString()),
                          );
                        }
                        if (!snapshot.hasData) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }

                        final data = snapshot.requireData;

                        return data.size > 0
                            ? ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: data.size,
                                itemBuilder: (context, index) {
                                  return _CommandItem(
                                    model: data.docs[index].data(),
                                    reference: data.docs[index].reference,
                                  );
                                },
                              )
                            : const Center(
                                child: Text("댓글을 달아보세요."),
                              );
                      },
                    ),
                  ))),
        ],
      ),
    );
  }
}

class _CommandItem extends GetView<HomeController> {
  _CommandItem({required this.model, required this.reference});

  var show = false;

  final CommandsModel model;
  final DocumentReference<CommandsModel> reference;

  @override
  Widget build(BuildContext context) {
    bool isOwner = model.userId == controller.userId;
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
                      Text(TimeUtils.timeAgo(
                          milliseconds: model.regDate.millisecondsSinceEpoch)),
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
                                padding: const EdgeInsets.only(right: 5.0),
                                child: const Icon(
                                  Icons.people,
                                  size: 15.0,
                                  color: Colors.blueAccent,
                                ),
                              ),
                            ),
                            model.userId == controller.userId
                                ? WidgetSpan(
                                    child: Container(
                                      padding: const EdgeInsets.only(
                                          left: 15.0, right: 2.0),
                                      child: const Icon(
                                        Icons.clear,
                                        size: 15.0,
                                        color: Colors.red,
                                      ),
                                    ),
                                  )
                                : const WidgetSpan(child: SizedBox()),
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
