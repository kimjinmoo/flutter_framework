import 'package:app/pages/home/presentation/controllers/home_controller.dart';
import 'package:app/pages/home/presentation/controllers/maker_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:numberpicker/numberpicker.dart';

///
/// 로또번호를 생성한다.
///
class Maker extends GetView {

  @override
  Widget build(BuildContext context) {
    Get.put(HomeController());
    Get.put(MakerController());
    return GetBuilder<MakerController>(
      builder: (controller) => Scaffold(
        appBar: AppBar(
            iconTheme: const IconThemeData(color: Colors.black),
            title:
            const Text("AI 번호 생성기", style: TextStyle(color: Colors.black)),
            backgroundColor: Colors.transparent,
            elevation: 0.0
        ),
        body: Container(
          alignment: Alignment.center,
          child: Obx(()=>Column(
            children: [
              Container(
                padding: const EdgeInsets.only(top: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Checkbox(
                        value: controller.numAutos.value[0],
                        onChanged: (value) => controller.onChange(0, value!)),
                    controller.numAutos.value[0] ? const Text("자동") : const Text("수동"),
                    !controller.numAutos.value[0] ?
                    NumberPicker(
                        axis: Axis.horizontal,
                        haptics: true,
                        minValue: 1,
                        maxValue: 45,
                        value: controller.number.value[0],
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.black26),
                        ),
                        onChanged: (value) => controller.onChangeValue(0, value, 1, 45)):const Text("")
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Checkbox(
                        value: controller.numAutos.value[1],
                        onChanged: (value) => controller.onChange(1, value!)),
                    controller.numAutos.value[1] ? const Text("자동") : const Text("수동"),
                    !controller.numAutos.value[1] ?NumberPicker(
                        axis: Axis.horizontal,
                        haptics: true,
                        minValue: 1,
                        maxValue: 45,
                        value: controller.number.value[1],
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.black26),
                        ),
                        onChanged: (value) => controller.onChangeValue(1, value, 1, 45)):const Text("")
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Checkbox(
                        value: controller.numAutos.value[2],
                        onChanged: (value) => controller.onChange(2, value!)),
                    controller.numAutos.value[2] ? const Text("자동") : const Text("수동"),
                    !controller.numAutos.value[2] ?NumberPicker(
                        axis: Axis.horizontal,
                        haptics: true,
                        minValue: 1,
                        maxValue: 45,
                        value: controller.number.value[2],
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.black26),
                        ),
                        onChanged: (value) => controller.onChangeValue(2, value, 1, 45)):const Text("")
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Checkbox(
                        value: controller.numAutos.value[3],
                        onChanged: (value) => controller.onChange(3, value!)),
                    controller.numAutos.value[3] ? const Text("자동") : const Text("수동"),
                    !controller.numAutos.value[3] ?NumberPicker(
                        axis: Axis.horizontal,
                        haptics: true,
                        minValue: 1,
                        maxValue: 45,
                        value: controller.number.value[3],
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.black26),
                        ),
                        onChanged: (value) => controller.onChangeValue(3, value, 1, 45)):Text("")
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Checkbox(
                        value: controller.numAutos.value[4],
                        onChanged: (value) => controller.onChange(4, value!)),
                    controller.numAutos.value[4] ? const Text("자동") : const Text("수동"),
                    !controller.numAutos.value[4] ?NumberPicker(
                        axis: Axis.horizontal,
                        haptics: true,
                        minValue: 1,
                        maxValue: 45,
                        value: controller.number.value[4],
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.black26),
                        ),
                        onChanged: (value) => controller.onChangeValue(4, value, 1, 45)):const Text("")
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Checkbox(
                        value: controller.numAutos.value[5],
                        onChanged: (value) => controller.onChange(5, value!)),
                    controller.numAutos.value[5] ? const Text("자동") : const Text("수동"),
                    !controller.numAutos.value[5] ?NumberPicker(
                        axis: Axis.horizontal,
                        haptics: true,
                        minValue: 1,
                        maxValue: 45,
                        value: controller.number.value[5],
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.black26),
                        ),
                        onChanged: (value) => controller.onChangeValue(5, value, 1, 45)):const Text("")
                  ],
                ),
              ),
            ],
          )),
        ),
        bottomNavigationBar: GetBuilder<HomeController>(
            builder: (homeController) {
              return Obx(()=>ElevatedButton.icon(
                  onPressed: (controller.isProcess.value || homeController.isProgress.value)?null:() async => {
                    controller.onCheckLottoNumber(),
                    if(controller.isValid.value) {
                      // 현재 회차 조회
                      await homeController.fetchCurrentRoundInit(),
                      // 등록
                      await controller
                                .createNumbers(
                                    homeController.userId.value,
                                    homeController.nRound.value,
                                    controller.getValues(),
                                    0)
                                .onError((error, stackTrace) =>
                                    Get.snackbar("에러", "로또 번호 등록에 실패 하였습니다.", snackPosition: SnackPosition.BOTTOM,)),
                            // 현재 회차 조회
                      await homeController.setRound(homeController.nRound.value),
                      // 넘버를 표시한다.
                      Get.back()
                    } else {
                      Get.snackbar("경고", "중복된 번호가 존재합니다.",
                        backgroundColor: Colors.redAccent,
                        snackPosition: SnackPosition.TOP,
                        forwardAnimationCurve: Curves.elasticInOut,
                        reverseAnimationCurve: Curves.easeOut,)
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red, // we can set primary color
                    onPrimary: Colors.black87, // change color of child prop
                    onSurface: Colors.blue, // surface color
                    shadowColor: Colors.grey,
                    minimumSize: Size.fromHeight(70),
                  ),
                  icon: (controller.isProcess.value || homeController.isProgress.value)?const CircularProgressIndicator():const FaIcon(FontAwesomeIcons.inbox),
                  label: const Text("번호 생성", style: TextStyle(color: Colors.white),)));
            }),
      ),
    );
  }
}

class NumericalRangeFormatter extends TextInputFormatter {
  final double min;
  final double max;

  NumericalRangeFormatter({required this.min, required this.max});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text == '') {
      return newValue;
    } else if (int.parse(newValue.text) < min) {
      return const TextEditingValue().copyWith(text: min.toStringAsFixed(2));
    } else {
      return int.parse(newValue.text) > max ? oldValue : newValue;
    }
  }
}
