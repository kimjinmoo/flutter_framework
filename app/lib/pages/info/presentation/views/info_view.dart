import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lotto/routes/app_pages.dart';

///
///
/// 정보
///
class Info extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("통계", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
            Padding(padding: EdgeInsets.only(left: 5, top: 5), child: Text("생성된 번호 데이터로 통계를 제공합니다."),),
            SizedBox(height: 10,),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Padding(padding: EdgeInsets.all(5), child: InkWell(
                    onTap: () {
                      Get.toNamed(Routes.STATUS);
                    },
                    child: Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade500)
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(child:FittedBox(child: Icon(Icons.bar_chart, color: Colors.purple),fit: BoxFit.fill)),
                          Text("회차 별 통계")
                        ],
                      ),
                    ),
                  ),),
                  Padding(padding: EdgeInsets.all(5), child: InkWell(
                    onTap: () {
                      Get.toNamed(Routes.TOTAL_STATUS);
                    },
                    child: Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade500)
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(child:FittedBox(child: Icon(Icons.area_chart, color: Colors.purple),fit: BoxFit.fill)),
                          Text("총 번호")
                        ],
                      ),
                    ),
                  ),),
                ],
              ),
            )
          ],
          ),
        ),
      ),
    );
  }
}
