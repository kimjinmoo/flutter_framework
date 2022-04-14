import 'package:app/services/api_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:numberpicker/numberpicker.dart';

class Maker extends StatefulWidget {
  @override
  State createState() {
    return MakerState();
  }
}

// 로또번호 생성기
class MakerState extends State<Maker> {

  // 번호
  List<int> number = [1,2,3,4,5,6];

  // 자동 생성 여부
  bool _numAuto1 = true;

  // 자동 생성 여부
  bool _numAuto2 = true;

  // 자동 생성 여부
  bool _numAuto3 = true;

  // 자동 생성 여부
  bool _numAuto4 = true;

  // 자동 생성 여부
  bool _numAuto5 = true;

  // 자동 생성 여부
  bool _numAuto6 = true;

  // 값을 체크 한다.
  checkValue(num, minValue, maxValue) {
    int checkNumber = num;
    // 최대값을 초과 하면 최소값으로 변경한다.
    if(checkNumber > maxValue ) {
      checkNumber = minValue;
    }
    if(number.contains(checkNumber)) {
      return checkValue(checkNumber+1, minValue, maxValue);
    }
    return checkNumber;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("번호 생성"),
        ),
        body: Container(
          alignment: Alignment.center,
          child: Column(
            children: [
              Text('${dotenv.env['API_URL']}'),
              Container(
                padding: const EdgeInsets.only(top: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Checkbox(
                        value: _numAuto1,
                        onChanged: (value) => setState(() => _numAuto1 = value!)),
                    _numAuto1 ? const Text("자동") : const Text("수동"),
                    !_numAuto1 ?
                    NumberPicker(
                        axis: Axis.horizontal,
                        haptics: true,
                        minValue: 1,
                        maxValue: 45,
                        value: number[0],
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.black26),
                        ),
                        onChanged: (value) => setState(() {
                          number[0] = checkValue(value, 1, 45);
                        })):const Text("")
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Checkbox(
                        value: _numAuto2,
                        onChanged: (value) => setState(() => _numAuto2 = value!)),
                    _numAuto2 ? const Text("자동") : const Text("수동"),
                    !_numAuto2 ?NumberPicker(
                        axis: Axis.horizontal,
                        haptics: true,
                        minValue: 1,
                        maxValue: 45,
                        value: number[1],
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.black26),
                        ),
                        onChanged: (value) => setState(() {
                          number[1] = checkValue(value, 1, 45);
                        })):const Text("")
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Checkbox(
                        value: _numAuto3,
                        onChanged: (value) => setState(() => _numAuto3 = value!)),
                    _numAuto3 ? const Text("자동") : const Text("수동"),
                    !_numAuto3 ?NumberPicker(
                        axis: Axis.horizontal,
                        haptics: true,
                        minValue: 1,
                        maxValue: 45,
                        value: number[2],
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.black26),
                        ),
                        onChanged: (value) => setState(() {
                          number[2] = checkValue(value, 1, 45);
                        })):const Text("")
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Checkbox(
                        value: _numAuto4,
                        onChanged: (value) => setState(() => _numAuto4 = value!)),
                    _numAuto4 ? const Text("자동") : const Text("수동"),
                    !_numAuto4 ?NumberPicker(
                        axis: Axis.horizontal,
                        haptics: true,
                        minValue: 1,
                        maxValue: 45,
                        value: number[3],
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.black26),
                        ),
                        onChanged: (value) => setState(() {
                          number[3] = checkValue(value, 1, 45);
                        })):Text("")
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Checkbox(
                        value: _numAuto5,
                        onChanged: (value) => setState(() => _numAuto5 = value!)),
                    _numAuto5 ? const Text("자동") : const Text("수동"),
                    !_numAuto5 ?NumberPicker(
                        axis: Axis.horizontal,
                        haptics: true,
                        minValue: 1,
                        maxValue: 45,
                        value: number[4],
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.black26),
                        ),
                        onChanged: (value) => setState(() {
                          number[4] = checkValue(value, 1, 45);
                        })):const Text("")
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Checkbox(
                        value: _numAuto6,
                        onChanged: (value) => setState(() => _numAuto6 = value!)),
                    _numAuto6 ? const Text("자동") : const Text("수동"),
                    !_numAuto6 ?NumberPicker(
                        axis: Axis.horizontal,
                        haptics: true,
                        minValue: 1,
                        maxValue: 45,
                        value: number[5],
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.black26),
                        ),
                        onChanged: (value) => setState(() {
                          number[5] = checkValue(value, 1, 45);
                        })):const Text("")
                  ],
                ),
              ),
              ElevatedButton.icon(
                  onPressed: () => {
                    fetchWinningLottoNumbers(number).then((value) => {
                      // 넘버를 표시한다.
                      Fluttertoast.showToast(msg:value.numbers.toString())
                    }).catchError((error,stackTrace)=>{
                      Fluttertoast.showToast(msg:error)
                    })
                  },
                  icon: const FaIcon(FontAwesomeIcons.inbox),
                  label: const Text("생성하기"))
            ],
          ),
        ));
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
