import 'package:lotto/pages/home/domain/rank.dart';
import 'package:lotto/pages/home/presentation/controllers/home_controller.dart';
import 'package:lotto/pages/maker/presentation/controllers/maker_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

// 이주 로또 기록
class History extends GetView {

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find();
    final MakerController makeController = Get.find();

    // 업데이트된 count 변수에 연결
    return Scaffold(
        key: controller.scaffoldKey,
        appBar: AppBar(
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.black),
          title: Text("${controller.currentRound}회차",
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
                    "회차변경",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
              onSelected: (item) {
                switch(item) {
                  case 0:
                    Scaffold.of(context).showBottomSheet<void>(
                          (BuildContext context) {
                        return Container(
                          height: 200,
                          color: Colors.amber,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                const Text('BottomSheet'),
                                ElevatedButton(
                                    child: const Text('Close BottomSheet'),
                                    onPressed: () {
                                      Get.back();
                                    })
                              ],
                            ),
                          ),
                        );
                      },
                    );
                    break;
                }
              },
            ),
          ],
        ),
        body: list(controller, makeController));
  }

  /// 리스트
  Widget list(HomeController controller, MakerController makerController) {
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
                                  Text("1", style: TextStyle(color: Colors.black54))
                              ),
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
                                      : IconButton(onPressed: (){
                                        Get.dialog(AlertDialog(
                                          title: Text("제거", style: TextStyle(fontWeight: FontWeight.bold),),
                                          content: Text("추출된 번호를 제거 하려고 합니다.\n삭제 하시겠습니까?"),
                                          actions: [
                                            TextButton(onPressed: () async {
                                              await makerController.deleteNumber(controller.currentRound.value, inx);
                                              await controller.fetchMyCurrentRoundLottoHistory();
                                              Get.back();
                                            }, child: Text("삭제", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),)
                                            ),
                                            TextButton(onPressed: (){Get.back();}, child: Text("취소", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold))),
                                          ],
                                        ));
                                  }, icon: Icon(Icons.remove_circle, color: Colors.red,))),
                        );
                      }),
            ),
          )
        : Center(
            child: const Text("생성한 번호가 없습니다."),
          ));
  }
}
