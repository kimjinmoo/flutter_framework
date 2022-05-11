import 'package:app/pages/home/domain/entity/user_lotto_model.dart';
import 'package:app/pages/home/presentation/controllers/home_controller.dart';
import 'package:app/services/firebase_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// 이주 로또 기록
class Week extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    // 업데이트된 count 변수에 연결
    return Scaffold(
        appBar: AppBar(
            centerTitle: true,
            iconTheme: const IconThemeData(color: Colors.black),
            title:
                const Text("내가 뽑은 번호", style: TextStyle(color: Colors.black)),
            backgroundColor: Colors.transparent,
            elevation: 0.0),
        body: Obx(() => Container(
              alignment: Alignment.center,
              child: Center(
                child: FutureBuilder<UserLottoModel>(
                  future: fetchMyLotto(
                      controller.round.value, controller.userId.value),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done &&
                        snapshot.hasData) {
                      return ListView.builder(
                          itemCount: snapshot.data?.numbers.length,
                          itemBuilder: (con, inx) {
                            return DataTable(
                              columns: [
                                DataColumn(
                                    label: Text('횟차',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold))),
                                DataColumn(
                                    label: Text('번호',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold))),
                                DataColumn(
                                    label: Text('등수',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold))),
                              ],
                              rows: [
                                DataRow(cells: [
                                  DataCell(Text("${inx + 1}")),
                                  DataCell(Text(
                                      "${snapshot.data?.numbers[inx].getWinningNumber()}",
                                      style: TextStyle(fontSize: 20))),
                                  DataCell(Text(""))
                                ])
                              ],
                            );
                          });
                    }
                    return Container();
                  },
                ),
              ),
            )));
  }
}
