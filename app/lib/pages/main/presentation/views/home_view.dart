import 'package:app/pages/accoount/controllers/auth_controller.dart';
import 'package:app/pages/main/domain/entity/commands_model.dart';
import 'package:app/pages/main/presentation/controllers/home_controller.dart';
import 'package:app/routes/app_pages.dart';
import 'package:app/services/firebase_service.dart';
import 'package:app/utils/time_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

// 홈
class Home extends StatelessWidget {

  ///
  /// 댓글 하단 시트
  ///
  void _showBottomSheet(BuildContext context, HomeController controller) {
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
                        0.17 +
                        (controller.getCommentLine() * 0.01),
                    minChildSize: keyboardHeight +
                        0.17 +
                        (controller.getCommentLine() * 0.01),
                    maxChildSize: keyboardHeight + 0.36,
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
                                      child: const FaIcon (FontAwesomeIcons.pencil, size: 20,),
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

  // 컨텐츠 타이틀
  TextStyle contentsTitle = GoogleFonts.notoSans(
    fontSize: 18, color: Colors.black87, fontWeight: FontWeight.w700,
  );
  // const TextStyle(
  //     fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black);

  ///
  /// 콤마
  ///
  String comma(number) {
    if(number == null) return "0";
    var f = NumberFormat('###,###,###,###,###,###,###,###');
    return f.format(number);
  }



  @override
  Widget build(context) {
    // 컨트롤러
    final AuthController authController = Get.find();
    final HomeController controller = Get.find();
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    // 광고 리스터 생성
    final BannerAdListener listener = BannerAdListener(
      // Called when an ad is successfully received.
      onAdLoaded: (Ad ad) => print('Ad loaded.'),
      // Called when an ad request failed.
      onAdFailedToLoad: (Ad ad, LoadAdError error) {
        // Dispose the ad here to free resources
        ad.dispose();
        print('Ad failed to load: $error');
      },
      // Called when an ad opens an overlay that covers the screen.
      onAdOpened: (Ad ad) => print('Ad opened.'),
      // Called when an ad removes an overlay that covers the screen.
      onAdClosed: (Ad ad) => print('Ad closed.'),
      // Called when an impression occurs on the ad.
      onAdImpression: (Ad ad) => print('Ad impression.'),
    );
    // Admob 광고
    BannerAd _bannerAd = BannerAd(
      adUnitId: 'ca-app-pub-3940256099942544/2934735716',
      size: AdSize.banner,
      request: const AdRequest(),
      listener: listener,
    );
    // 광고 로딩
    _bannerAd.load();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      // count가 변경 될 때마다 Obx(()=> 를 사용하여 Text()에 업데이트합니다.
      appBar: AppBar(
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text("ㅈㅈㄱ로또", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            SizedBox(
              height: 100,
              child: DrawerHeader(
                margin: EdgeInsets.zero,
                padding: EdgeInsets.zero,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Obx(() => Text(
                      authController.userName.value,
                      style:
                      const TextStyle(color: Colors.black54, fontSize: 20),
                    )),
                    IconButton(
                        onPressed: () {
                          Get.toNamed("${Routes.SIDE}${Routes.SIDE_SETTING}");
                        },
                        icon: const Icon(
                          Icons.settings,
                          color: Colors.black54,
                          size: 20,
                        )),
                  ],
                ),
                decoration: const BoxDecoration(
                  color: Colors.white,

                ),
              ),
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
      body: Obx(() => authController.user.value.isLogin
          ? list(context, authController, controller, _bannerAd)
          : SizedBox()),
    );
  }

  Widget list(context,
      AuthController authController, HomeController controller, BannerAd bannerAd) {
    return controller.isProgress.value
        ? Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            enabled: true,
            child: Column(
              children: [
                const Padding(padding: EdgeInsets.only(bottom: 5)),
                Row(
                  children: [
                    Container(
                      alignment: Alignment.topLeft,
                      padding: const EdgeInsets.only(left: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.black,
                      ),
                      height: 25,
                      child: Text("0000 회차 당첨번호", style: contentsTitle),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Obx(() => IconButton(
                        onPressed: controller.isProgress.value
                            ? null
                            : () {
                          controller.toPreviousRound().onError(
                                  (error, stackTrace) =>
                                  Get.snackbar("안내", error.toString()));
                        },
                        icon: const FaIcon(FontAwesomeIcons.angleLeft))),
                    Expanded(
                        flex: 1,
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.black,
                          ),
                          height: 40,
                        )),
                    Obx(() => controller.winningNumberInfo.value != null
                        ? IconButton(
                        onPressed: controller.isProgress.value
                            ? null
                            : () {
                          controller.toNextRound().onError(
                                  (error, stackTrace) =>
                                  HapticFeedback.heavyImpact());
                        },
                        icon: const FaIcon(FontAwesomeIcons.angleRight))
                        : const IconButton(
                        onPressed: null,
                        icon: FaIcon(FontAwesomeIcons.angleRight)))
                  ],
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    width: 150,
                    padding: EdgeInsets.only(left: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.black,
                    ),
                    child: Text("당첨 정보", style: TextStyle(
                        color: Colors.black54,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                InkWell(
                  child: SizedBox(
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
                  onTap: () => {_showBottomSheet(context, controller)},
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
                            CommandsQuery.createDateDesc,
                            controller.currentRound.value),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Center(
                              child: Text(snapshot.error.toString()),
                            );
                          }
                          if (!snapshot.hasData) {
                            return SizedBox();
                          }

                          final data = snapshot.requireData;

                          return data.size > 0
                              ? ListView.builder(
                            physics:
                            const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: data.size,
                            itemBuilder: (context, index) {
                              return _CommandItem(
                                model: data.docs[index].data(),
                                reference:
                                data.docs[index].reference,
                                isOwner: data.docs[index]
                                    .data()
                                    .userId ==
                                    authController
                                        .user.value.userId,
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
          )
        : Column(
            children: [
              const Padding(padding: EdgeInsets.only(bottom: 5)),
              Row(
                children: [
                  Container(
                    alignment: Alignment.topLeft,
                    padding: const EdgeInsets.only(left: 10),
                    height: 25,
                    child: Obx(() => Text(
                        "${controller.currentRound.value} 회차 당첨번호",
                        style: contentsTitle)),
                  ),
                  controller.nextRound.value != controller.currentRound.value?
                  Expanded(
                      flex: 1,
                      child: InkWell(
                        onTap: () {
                          controller.setRound(controller.nextRound.value);
                        },
                        child: Padding(
                          padding: EdgeInsets.only(right: 10),
                          child: Align(
                            alignment: Alignment.topRight,
                            child: Icon(Icons.home_filled, size: 20, color: Colors.blue,),
                          ),
                        ),
                      )
                  ):SizedBox()
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Obx(() => IconButton(
                      onPressed: controller.isProgress.value
                          ? null
                          : () {
                              controller.toPreviousRound().onError(
                                  (error, stackTrace) =>
                                      Get.snackbar("안내", error.toString()));
                            },
                      icon: const FaIcon(FontAwesomeIcons.angleLeft))),
                  Expanded(
                      flex: 1,
                      child: Container(
                        alignment: Alignment.center,
                        child: Obx(() =>
                            controller.winningNumberInfo.value != null?
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                createCircle(controller.winningNumberInfo.value?.num1),
                                createCircle(controller.winningNumberInfo.value?.num2),
                                createCircle(controller.winningNumberInfo.value?.num3),
                                createCircle(controller.winningNumberInfo.value?.num4),
                                createCircle(controller.winningNumberInfo.value?.num5),
                                createCircle(controller.winningNumberInfo.value?.num6),
                                Text("+"),
                                createCircle(controller.winningNumberInfo.value?.numEx),
                              ],
                            ):
                            Text("이번주 예정", style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54,
                                  fontSize: 21),
                            )),
                        height: 40,
                      )),
                  Obx(() =>
                      IconButton(
                          onPressed: (controller.isProgress.value || controller.winningNumberInfo.value == null)
                              ? null
                              : () {
                            controller.toNextRound().onError(
                                    (error, stackTrace) =>
                                    HapticFeedback.heavyImpact());
                          },
                          icon: const FaIcon(FontAwesomeIcons.angleRight)))
                ],
              ),
              // Container(
              //   alignment: Alignment.topLeft,
              //   padding: EdgeInsets.only(left: 10),
              //   child: ,
              // ),
              ExpansionTile(
                title: Row(
                  children: [
                    Text("당첨 정보",
                        style: contentsTitle),
                    controller.winningNumberInfo.value?.round != null
                        ? Icon(Icons.check_box)
                        : Icon(Icons.indeterminate_check_box),
                  ],
                ),
                children: [
                  Container(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                                "1등 당첨금액: ${comma(controller.winningNumberInfo.value?.getPrice()[0])}원"),
                            Expanded(flex: 2,child: Text("${comma(controller.winningNumberInfo.value?.getWinners()[0])}명"))
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                                "2등 당첨금액: ${comma(controller.winningNumberInfo.value?.getPrice()[1])}원"),
                            Text("${comma(controller.winningNumberInfo.value?.getWinners()[1])}명")
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                                "3등 당첨금액: ${comma(controller.winningNumberInfo.value?.getPrice()[2])}원"),
                            Text("${comma(controller.winningNumberInfo.value?.getWinners()[2])}명")
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                                "4등 당첨금액: ${comma(controller.winningNumberInfo.value?.getPrice()[3])}원"),
                            Text("${comma(controller.winningNumberInfo.value?.getWinners()[3])}명")
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                                "5등 당첨금액: ${comma(controller.winningNumberInfo.value?.getPrice()[4])}원"),
                            Text("${comma(controller.winningNumberInfo.value?.getWinners()[4])}명")
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
              Container(
                alignment: Alignment.center,
                height: bannerAd.size.height.toDouble(),
                width: bannerAd.size.width.toDouble(),
                color: Colors.grey.shade300,
                child: AdWidget(ad: bannerAd),
              ),
              // Container(
              //   alignment: Alignment.topLeft,
              //   padding: EdgeInsets.only(left: 10, top: 5),
              //   child:
              //   controller.winningNumberInfo.value?.round != null?
              //       Container(
              //           child: Column(
              //         children: [
              //
              //         ],
              //       ))
              //   :Center(child: Text("광고")),
              // ),
              const SizedBox(
                height: 5,
              ),
              InkWell(
                child: SizedBox(
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
                onTap: () => {_showBottomSheet(context, controller)},
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
                              CommandsQuery.createDateDesc,
                              controller.currentRound.value),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return Center(
                                child: Text(snapshot.error.toString()),
                              );
                            }
                            if (!snapshot.hasData) {
                              return SizedBox();
                            }

                            final data = snapshot.requireData;

                            return data.size > 0
                                ? ListView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: data.size,
                                    itemBuilder: (context, index) {
                                      return _CommandItem(
                                        model: data.docs[index].data(),
                                        reference: data.docs[index].reference,
                                        isOwner: data.docs[index]
                                                .data()
                                                .userId ==
                                            authController.user.value.userId,
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
          );
  }

  /// 로또 번호 볼 생성
  Widget createCircle(int? number) {
    var bgColor = Color.fromRGBO(255, 212, 0, 1.0);
    var textColor = Color.fromRGBO(255, 255, 255, 1.0);
    if(number! < 11) {
      bgColor = Color.fromRGBO(255, 212, 0, 1.0);
      textColor = Color.fromRGBO(0, 0, 0, 1.0);
    }
    else if(number > 10 && number < 21) {
      bgColor = Color.fromRGBO(70, 130, 180, 1.0);
    }
    else if(number > 20 && number < 31) {
      bgColor = Color.fromRGBO(255, 0, 0, 1.0);
    }
    else if(number > 30 && number < 41) {
      bgColor = Color.fromRGBO(0, 0, 0, 1.0);
    }
    else if(number > 40 && number < 50) {
      bgColor = Color.fromRGBO(0, 128, 0, 1.0);
    }
    return CircleAvatar(
      minRadius: 17,
      maxRadius: 17,
      backgroundColor: bgColor,
      child: Center(
        child: Text(number.toString().padLeft(2, '0'), style: TextStyle(color: textColor, fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class _CommandItem extends GetView<HomeController> {
  _CommandItem(
      {required this.model, required this.isOwner, required this.reference});

  // 소유권자
  final bool isOwner;

  //댓글 모델
  final CommandsModel model;

  // 댓글 화이어베이스 객체
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
                            )
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
                                  size: 25.0,
                                  color: Colors.blueAccent,
                                ),
                              ),
                            ),
                            isOwner
                                ? WidgetSpan(
                                    child: Container(
                                      padding: const EdgeInsets.only(
                                          left: 15.0, right: 2.0),
                                      child: InkWell(
                                        onTap: () {
                                          Get.dialog(AlertDialog(
                                            title: const Text(
                                              "경고",
                                              style:
                                                  TextStyle(color: Colors.red),
                                            ),
                                            content: const Text("삭제하시겠습니까?"),
                                            actions: [
                                              TextButton(
                                                  onPressed: () => Get.back(),
                                                  child: const Text("취소")),
                                              TextButton(
                                                  onPressed: () async => {
                                                        await controller
                                                            .removeComment(
                                                                reference.id),
                                                        Get.back()
                                                      },
                                                  child: const Text(
                                                    "삭제",
                                                    style: TextStyle(
                                                        color: Colors.red),
                                                  )),
                                            ],
                                          ));
                                        },
                                        child: const Icon(
                                          Icons.delete,
                                          size: 25.0,
                                          color: Colors.red,
                                        ),
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
