import 'package:app/pages/accoount/controllers/auth_controller.dart';
import 'package:app/pages/main/domain/rank.dart';
import 'package:app/pages/main/presentation/controllers/home_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

// 이주 로또 기록
class Week extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find();
    // Get.put()을 사용하여 클래스를 인스턴스화하여 모든 "child'에서 사용가능하게 합니다.
    final HomeController controller = Get.find();
    // 업데이트된 count 변수에 연결
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.black),
          title: Text("내 번호 - ${controller.currentRound}회차",
              style: TextStyle(color: Colors.black)),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          actions: [
            PopupMenuButton(
              icon: Icon(Icons.filter_alt),
              itemBuilder: (_) => [
                PopupMenuItem<int>(
                  value: 0,
                  child: Text(
                    "옵션",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
              onSelected: (item) => {print(item)},
            ),
          ],
        ),
        body: list(controller));
  }

  /// 리스트
  Widget list(HomeController controller) {
    return Obx(() => controller.myLottoHistory.value.numbers.isNotEmpty
        ? Container(
            alignment: Alignment.center,
            child: SizedBox(
              child: controller.isProgress.value
                  ? Shimmer.fromColors(
                      baseColor: Colors.grey.shade300,
                      highlightColor: Colors.grey.shade100,
                      enabled: true,
                      child: ListView.builder(
                          itemCount:
                              controller.myLottoHistory.value.numbers.length,
                          itemBuilder: (con, inx) {
                            return Card(
                              elevation: 0.0,
                              child: ListTile(
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 10.0),
                                  leading: Text("${inx + 1}"),
                                  title: Text(
                                    controller.myLottoHistory.value.numbers[inx]
                                        .getWinningNumber(),
                                    style: TextStyle(
                                        color: Colors.black54,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  trailing:
                                      controller.winningNumberInfo.value != null
                                          ? Text("1",
                                              style: TextStyle(
                                                  color: Colors.black54))
                                          : Text("진행중")),
                            );
                          }),
                    )
                  : ListView.builder(
                      itemCount: controller.myLottoHistory.value.numbers.length,
                      itemBuilder: (con, inx) {
                        Rank rank = controller.rank(controller
                            .myLottoHistory.value.numbers[inx]
                            .toArray());
                        TextStyle rankStyle = rank.rank > 0
                            ? TextStyle(color: Colors.red)
                            : TextStyle(color: Colors.grey);
                        return Card(
                          elevation: 0.0,
                          child: ListTile(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 10.0),
                              leading: Text("${inx + 1}"),
                              title: Text(
                                controller.myLottoHistory.value.numbers[inx]
                                    .getWinningNumber(),
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.bold),
                              ),
                              trailing:
                                  controller.winningNumberInfo.value != null
                                      ? Text(rank.rankName, style: rankStyle)
                                      : Text("진행중")),
                        );
                      }),
            ),
          )
        : Center(
            child: const Text("생성한 번호가 없습니다."),
          ));
  }
}
