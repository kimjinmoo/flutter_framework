import 'package:lotto/pages/account/domain/entity/user_model.dart';
import 'package:lotto/pages/account/presentation/controllers/auth_controller.dart';
import 'package:lotto/pages/home/domain/entity/commands_model.dart';
import 'package:lotto/pages/home/domain/entity/help_service_model.dart';
import 'package:lotto/pages/home/presentation/controllers/home_controller.dart';
import 'package:lotto/pages/home/presentation/controllers/landing_controller.dart';
import 'package:lotto/services/firebase_service.dart';
import 'package:lotto/ui/common_widget.dart';
import 'package:lotto/utils/ad_utils.dart';
import 'package:lotto/utils/time_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:lotto/utils/validation_utils.dart';
import 'package:shimmer/shimmer.dart';

// 홈
class Home extends StatelessWidget {
  ///
  /// 댓글 하단 시트
  ///
  void _showBottomCommentSheet(
      BuildContext context, HomeController controller) {
    const errMsg = SnackBar(
        backgroundColor: Colors.red, content: Text('사용할수 없는 단어가 포함되어 있습니다.'));
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
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: 5),
                                child: Text(
                                  "댓글을 사용시 타인을 존중하고 가이드를 준수해야 합니다.",
                                  style: TextStyle(fontSize: 12),
                                ),
                              ),
                              TextField(
                                controller: controller.commentController,
                                keyboardType: TextInputType.multiline,
                                maxLines: 3,
                                textInputAction: TextInputAction.newline,
                                decoration: InputDecoration(
                                    hintText: '댓글 남기기...',
                                    contentPadding: EdgeInsets.all(8.0),
                                    suffixIcon: InkWell(
                                      onTap: () => {
                                        if (controller.comment.value.isNotEmpty)
                                          {
                                            if (!isBlackListCheck(controller
                                                .commentController.text))
                                              {
                                                controller.addComment(),
                                                Get.back()
                                              }
                                            else
                                              {
                                                controller.clear(),
                                                Get.back(),
                                                HapticFeedback.heavyImpact(),
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(errMsg)
                                              }
                                          }
                                      },
                                      child: FaIcon(
                                        FontAwesomeIcons.keyboard,
                                        size: 18,
                                        color: controller.comment.value.isEmpty
                                            ? Colors.black26
                                            : Colors.pink,
                                      ),
                                    )),
                                autofocus: true,
                                // onSubmitted: (value) {
                                //   print("click!!");
                                //   addCommand();
                                // },
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                )),
          ),
        );
      },
    ).whenComplete(() => controller.clear());
  }

  // 컨텐츠 타이틀
  TextStyle contentsTitle = GoogleFonts.notoSans(
    fontSize: 19,
    color: Colors.black87,
    fontWeight: FontWeight.bold,
  );

  // 강조
  TextStyle contentsRedTitle = GoogleFonts.notoSans(
    fontSize: 19,
    color: Colors.red,
    fontWeight: FontWeight.bold,
  );

  ///
  /// 콤마
  ///
  String comma(number) {
    if (number == null) return "0";
    var f = NumberFormat('###,###,###,###,###,###,###,###');
    return f.format(number);
  }

  @override
  Widget build(context) {
    // 컨트롤러
    final AuthController authController = Get.find();
    final HomeController controller = Get.find();
    final LandingController landingController = Get.find();

    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
        resizeToAvoidBottomInset: false,
        // count가 변경 될 때마다 Obx(()=> 를 사용하여 Text()에 업데이트합니다.
        // 8줄의 Navigator.push를 간단한 Get.to()로 변경합니다. context는 필요없습니다.
        body: SafeArea(
          child: !controller.isError.value
              ? Obx(() => authController.user.value.isLogin
                  ? list(context, authController, controller, landingController)
                  : SizedBox())
              : Container(
                  child: Text("네트워크에 문제가 있습니다."),
                ),
        ));
  }

  Widget list(context, AuthController authController, HomeController controller,
      LandingController landingController) {
    return controller.isProgress.value
        ? Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            enabled: true,
            child: Column(
              mainAxisSize: MainAxisSize.min,
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
                    IconButton(
                        onPressed: controller.isProgress.value
                            ? null
                            : () {
                                controller.toPreviousRound().onError(
                                    (error, stackTrace) =>
                                        Get.snackbar("안내", error.toString()));
                              },
                        icon: const FaIcon(FontAwesomeIcons.angleLeft)),
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
                    controller.winningNumberInfo.value != null
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
                            icon: FaIcon(FontAwesomeIcons.angleRight))
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
                    child: Text("당첨 정보",
                        style: TextStyle(
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
                        style: GoogleFonts.notoSans(
                          fontSize: 16,
                          color: Theme.of(context).disabledColor,
                        ),
                      ),
                    ),
                  ),
                  onTap: () => {_showBottomCommentSheet(context, controller)},
                ),
                Divider(
                  thickness: 0.5,
                  color: Theme.of(context).disabledColor,
                ),
                Flexible(
                    fit: FlexFit.tight,
                    flex: 1,
                    child: SingleChildScrollView(
                      child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: 5,
                        itemBuilder: (context, index) {
                          CommandsModel fakeModel = CommandsModel(
                              userId: "test",
                              userName: "test",
                              command: "test",
                              isReport: "test",
                              round: 0,
                              regDate: Timestamp.now());
                          return _CommandItem(
                            model: fakeModel,
                            reference: null,
                            isOwner: false,
                          );
                        },
                      ),
                    )),
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
                    child: Text.rich(TextSpan(
                        text: "${controller.currentRound.value}",
                        style: contentsRedTitle,
                        children: [
                          TextSpan(text: "회차 당첨번호", style: contentsTitle)
                        ])),
                  ),
                  controller.nextRound.value != controller.currentRound.value
                      ? Expanded(
                          flex: 1,
                          child: InkWell(
                            onTap: () {
                              controller.setRound(controller.nextRound.value);
                            },
                            child: Padding(
                              padding: EdgeInsets.only(right: 10),
                              child: Align(
                                alignment: Alignment.topRight,
                                child: Icon(
                                  Icons.home_filled,
                                  size: 22,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          ))
                      : SizedBox()
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                      onPressed: controller.isProgress.value
                          ? null
                          : () {
                              controller.toPreviousRound().onError(
                                  (error, stackTrace) =>
                                      Get.snackbar("안내", error.toString()));
                            },
                      icon: const FaIcon(FontAwesomeIcons.angleLeft)),
                  Expanded(
                      flex: 1,
                      child: Container(
                        alignment: Alignment.center,
                        child: controller.winningNumberInfo.value != null
                            ? Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CommonWidget.createCircle(
                                      controller.winningNumberInfo.value?.num1),
                                  CommonWidget.createCircle(
                                      controller.winningNumberInfo.value?.num2),
                                  CommonWidget.createCircle(
                                      controller.winningNumberInfo.value?.num3),
                                  CommonWidget.createCircle(
                                      controller.winningNumberInfo.value?.num4),
                                  CommonWidget.createCircle(
                                      controller.winningNumberInfo.value?.num5),
                                  CommonWidget.createCircle(
                                      controller.winningNumberInfo.value?.num6),
                                  Text("+"),
                                  CommonWidget.createCircle(controller
                                      .winningNumberInfo.value?.numEx),
                                ],
                              )
                            : Text(
                                "이번주 발표",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black54,
                                    fontSize: 21),
                              ),
                        height: 40,
                      )),
                  IconButton(
                      onPressed: (controller.isProgress.value ||
                              controller.winningNumberInfo.value == null)
                          ? null
                          : () {
                              controller.toNextRound().onError(
                                  (error, stackTrace) =>
                                      HapticFeedback.heavyImpact());
                            },
                      icon: const FaIcon(FontAwesomeIcons.angleRight))
                ],
              ),
              Theme(
                data: Theme.of(context)
                    .copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  initiallyExpanded: true,
                  title: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: 5),
                        child: Text("당첨 추가 정보", style: contentsTitle),
                      ),
                      controller.winningNumberInfo.value?.round != null
                          ? Icon(Icons.today_rounded)
                          : SizedBox(),
                    ],
                  ),
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black12)),
                      child: controller.winningNumberInfo.value?.round != null
                          ? Padding(
                              padding: EdgeInsets.all(10),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                          "1등 당첨금액: ${comma(controller.winningNumberInfo.value?.getPrice()[0])}원"),
                                      Expanded(
                                          flex: 1,
                                          child: Align(
                                            alignment: Alignment.topRight,
                                            child: Text(
                                                "${comma(controller.winningNumberInfo.value?.getWinners()[0])}명"),
                                          ))
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                          "2등 당첨금액: ${comma(controller.winningNumberInfo.value?.getPrice()[1])}원"),
                                      Expanded(
                                          flex: 1,
                                          child: Align(
                                            alignment: Alignment.topRight,
                                            child: Text(
                                                "${comma(controller.winningNumberInfo.value?.getWinners()[1])}명"),
                                          ))
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                          "3등 당첨금액: ${comma(controller.winningNumberInfo.value?.getPrice()[2])}원"),
                                      Expanded(
                                          flex: 1,
                                          child: Align(
                                            alignment: Alignment.topRight,
                                            child: Text(
                                                "${comma(controller.winningNumberInfo.value?.getWinners()[2])}명"),
                                          ))
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                          "4등 당첨금액: ${comma(controller.winningNumberInfo.value?.getPrice()[3])}원"),
                                      Expanded(
                                          flex: 1,
                                          child: Align(
                                            alignment: Alignment.topRight,
                                            child: Text(
                                                "${comma(controller.winningNumberInfo.value?.getWinners()[3])}명"),
                                          ))
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                          "5등 당첨금액: ${comma(controller.winningNumberInfo.value?.getPrice()[4])}원"),
                                      Expanded(
                                          flex: 1,
                                          child: Align(
                                            alignment: Alignment.topRight,
                                            child: Text(
                                                "${comma(controller.winningNumberInfo.value?.getWinners()[4])}명"),
                                          ))
                                    ],
                                  )
                                ],
                              ),
                            )
                          : Container(
                              width: double.infinity,
                              height: 70,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("발표 대기"),
                                    Text.rich(TextSpan(
                                        text: "발표당일 등수 계산으로 ",
                                        children: <TextSpan>[
                                          TextSpan(
                                              text: "1~2시간 지연 ",
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontWeight: FontWeight.bold)),
                                          TextSpan(text: "됩니다.")
                                        ]))
                                  ],
                                ),
                              ),
                            ),
                    )
                  ],
                ),
              ),
              Obx(() => InkWell(
                    child: SizedBox(
                      width: double.infinity,
                      height: 30,
                      child: ColoredBox(
                          color: Colors.black87,
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                authController.user.value.privacyAgreementYn ==
                                        'N'
                                    ? const Padding(
                                        padding: EdgeInsets.only(right: 5),
                                        child: Icon(
                                          Icons.lock,
                                          color: Colors.pink,
                                          size: 20,
                                        ))
                                    : const SizedBox(),
                                Text(
                                  "댓글 남기기",
                                  style: GoogleFonts.notoSans(
                                      fontSize: 16, color: Colors.white70),
                                )
                              ],
                            ),
                          )),
                    ),
                    onTap: () => {
                      if (authController.user.value.privacyAgreementYn == 'Y')
                        {_showBottomCommentSheet(context, controller)}
                      else
                        {
                          landingController.changeTabIndex(4),
                          Get.snackbar("이용동의 확인",
                              "유저 정보의 자물쇠 아이콘을\n클릭하여 이용동의 후 이용 가능합니다.",
                              snackPosition: SnackPosition.TOP)
                        }
                    },
                  )),
              Divider(
                thickness: 0.5,
                color: Theme.of(context).disabledColor,
              ),
              Flexible(
                  fit: FlexFit.tight,
                  flex: 1,
                  child: SingleChildScrollView(
                    child: StreamBuilder<QuerySnapshot<CommandsModel>>(
                      stream: getFirebaseInstance(CommandsQuery.createDateDesc,
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
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: data.size,
                                itemBuilder: (context, index) {
                                  return _CommandItem(
                                    model: data.docs[index].data(),
                                    reference: data.docs[index].reference,
                                    isOwner: data.docs[index].data().userId ==
                                        authController.user.value.userId,
                                  );
                                },
                              )
                            : const Center(
                                child: Text("댓글을 달아보세요."),
                              );
                      },
                    ),
                  )),
            ],
          );
  }
}

/// 댓글 디자인
class _CommandItem extends GetView<HomeController> {
  _CommandItem(
      {required this.model, required this.isOwner, required this.reference});

  // 소유권자
  final bool isOwner;

  //댓글 모델
  final CommandsModel model;

  // 댓글 화이어베이스 객체
  final DocumentReference<CommandsModel>? reference;

  ///
  /// 유저 하단 옵션
  ///
  void _showBottomUserOptions(BuildContext context, userName, id) {
    const errMsg = SnackBar(
        backgroundColor: Colors.red, content: Text('사용할수 없는 단어가 포함되어 있습니다.'));
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
                  initialChildSize: 0.2,
                  minChildSize: 0.2,
                  maxChildSize: 0.2,
                  builder: (BuildContext context,
                      ScrollController scrollController) {
                    return Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 5),
                              child: Text(
                                userName,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Divider(height: 5),
                            InkWell(
                              onTap: () {
                                Get.dialog(AlertDialog(
                                  title: const Text(
                                    "유저 신고 접수",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  content: Container(
                                    child: Text(
                                        "불쾌감을 주는 언행을 했을 경우\n관리자 확인 후 삭제처리 합니다.\n신고 접수를 하시겠습니까?"),
                                  ),
                                  actions: [
                                    TextButton(
                                        onPressed: () async {
                                          HelpServiceModel m = HelpServiceModel(
                                              contents:
                                                  "[${userName}]신고 접수 요청 하였습니다.",
                                              subject: '유저신고',
                                              type: 3);
                                          await reportHelpService(m);
                                          Get.back();
                                          Get.snackbar(
                                              '확인', '접수 되었습니다. 확인 후 조치 하겠습니다.',
                                              snackPosition: SnackPosition.TOP);
                                          Navigator.pop(context);
                                        },
                                        child: const Text(
                                          "확인",
                                          style: TextStyle(
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold),
                                        )),
                                    TextButton(
                                        onPressed: () {
                                          Get.back();
                                        },
                                        child: const Text("취소",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold))),
                                  ],
                                ));
                              },
                              child: Padding(
                                padding: EdgeInsets.all(10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      "유저 신고하기",
                                      style: TextStyle(
                                          fontSize: 18, color: Colors.red),
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                )),
          ),
        );
      },
    ).whenComplete(() => controller.clear());
  }

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
            child: FutureBuilder<UserModel?>(
              future: getUser(model.userId),
              builder: (conx, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  // 유저 데이터
                  UserModel user = snapshot.data ??
                      UserModel(
                          userId: "test",
                          userName: "test",
                          regDate: Timestamp.now(),
                          maxRank: 0,
                          privacyAgreementYn: "N");
                  return ListView(
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.only(top: 20),
                    shrinkWrap: true,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () => _showBottomUserOptions(
                                  context, user.userName, reference?.id),
                              child: Text.rich(
                                TextSpan(
                                  children: [
                                    WidgetSpan(
                                      child: Container(
                                        margin: EdgeInsets.only(right: 4.0),
                                        width: 19,
                                        height: 19,
                                        decoration: new BoxDecoration(
                                            color: Colors.black87,
                                            border: new Border.all(
                                              color: Colors.black,
                                            ),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20))),
                                        child: Center(
                                          child: Text(
                                            user.userName.substring(0, 1),
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                    TextSpan(
                                      text: user.userName,
                                      style: GoogleFonts.notoSans(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                                flex: 1,
                                child: Align(
                                  alignment: Alignment.topRight,
                                  child: Text(TimeUtils.timeAgo(
                                      milliseconds: model
                                          .regDate.millisecondsSinceEpoch)),
                                )),
                          ],
                        ),
                      ),
                      Text(
                        model.command,
                        style: GoogleFonts.notoSans(
                            fontSize: 16, color: Colors.black54),
                        textAlign: TextAlign.left,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Divider(),
                      ),
                      Container(
                        margin: const EdgeInsets.only(bottom: 10, top: 10),
                        height: 20,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
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
                                  text: user.maxRank == 0
                                      ? "당첨 경험 없음"
                                      : "${user.maxRank}등 경험",
                                  style: TextStyle(color: Colors.black54))
                            ])),
                            Expanded(child: SizedBox()),
                            isOwner
                                ? Text.rich(
                                    TextSpan(
                                      style: Theme.of(context).textTheme.button,
                                      children: [
                                        isOwner
                                            ? WidgetSpan(
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 2.0),
                                                  child: InkWell(
                                                    onTap: () {
                                                      Get.dialog(AlertDialog(
                                                        title: const Text(
                                                          "경고",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.red),
                                                        ),
                                                        content: const Text(
                                                            "삭제하시겠습니까?"),
                                                        actions: [
                                                          TextButton(
                                                              onPressed:
                                                                  () async {
                                                                final reference =
                                                                    this.reference;
                                                                if (reference !=
                                                                    null) {
                                                                  await controller
                                                                      .removeComment(
                                                                          reference
                                                                              .id);
                                                                }
                                                                Get.back();
                                                              },
                                                              child: const Text(
                                                                "삭제",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .red,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              )),
                                                          TextButton(
                                                              onPressed: () =>
                                                                  Get.back(),
                                                              child: const Text(
                                                                "취소",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
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
                                            : const WidgetSpan(
                                                child: SizedBox()),
                                      ],
                                    ),
                                  )
                                : InkWell(
                                    onTap: () {
                                      Get.dialog(AlertDialog(
                                        title: const Text(
                                          "신고하기",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        content: const Text(
                                            "폭언,욕설등 문제 있는 내용이 포함되었나요?\n신고하시겠습니까?"),
                                        actions: [
                                          TextButton(
                                              onPressed: () async {
                                                final reference =
                                                    this.reference;
                                                if (reference != null) {
                                                  await reportComment(
                                                      reference.id);
                                                }
                                                Get.back();
                                              },
                                              child: const Text(
                                                "확인",
                                                style: TextStyle(
                                                    color: Colors.red,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )),
                                          TextButton(
                                              onPressed: () {
                                                Get.back();
                                              },
                                              child: const Text("취소",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold))),
                                        ],
                                      ));
                                    },
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 5, right: 5),
                                          child: FaIcon(
                                            FontAwesomeIcons.exclamation,
                                            size: 15,
                                          ),
                                        ),
                                        const Text("신고하기")
                                      ],
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ],
                  );
                } else {
                  return Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    enabled: true,
                    child: ListView(
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.only(top: 20),
                      shrinkWrap: true,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text.rich(
                                TextSpan(
                                  children: [
                                    WidgetSpan(
                                      child: Container(
                                        margin: EdgeInsets.only(right: 4.0),
                                        width: 19,
                                        height: 19,
                                        decoration: new BoxDecoration(
                                            color: Colors.black87,
                                            border: new Border.all(
                                              color: Colors.black,
                                            ),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20))),
                                        child: Center(
                                          child: Text(
                                            model.userName.substring(0, 1),
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                    TextSpan(
                                      text: model.userName,
                                      style: GoogleFonts.notoSans(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87),
                                    )
                                  ],
                                ),
                              ),
                              Expanded(
                                  flex: 1,
                                  child: Align(
                                    alignment: Alignment.topRight,
                                    child: Text(TimeUtils.timeAgo(
                                        milliseconds: model
                                            .regDate.millisecondsSinceEpoch)),
                                  )),
                            ],
                          ),
                        ),
                        Text(
                          model.command,
                          style: GoogleFonts.notoSans(
                              fontSize: 16, color: Colors.black26),
                          textAlign: TextAlign.left,
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Divider(),
                        ),
                        Container(
                          margin: const EdgeInsets.only(bottom: 10, top: 10),
                          height: 20,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text.rich(
                                TextSpan(
                                  style: Theme.of(context).textTheme.button,
                                  children: [
                                    isOwner
                                        ? WidgetSpan(
                                            child: Container(
                                              padding: const EdgeInsets.only(
                                                  right: 2.0),
                                              child: InkWell(
                                                onTap: () {},
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
                              InkWell(
                                onTap: () {},
                                child: const Text("신고하기"),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
          ),
        ),
        const SizedBox(
          height: 5,
        )
      ],
    );
  }
}
