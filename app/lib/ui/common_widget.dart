import 'package:flutter/material.dart';

///
/// 공통위젯
///
class CommonWidget {
  /// 로또 번호 볼 생성
  static Widget createCircle(int? number) {
    var bgColor = const Color.fromRGBO(255, 212, 0, 1.0);
    var textColor = const Color.fromRGBO(255, 255, 255, 1.0);
    if (number! < 11) {
      bgColor = const Color.fromRGBO(255, 212, 0, 1.0);
      textColor = const Color.fromRGBO(0, 0, 0, 1.0);
    } else if (number > 10 && number < 21) {
      bgColor = const Color.fromRGBO(70, 130, 180, 1.0);
    } else if (number > 20 && number < 31) {
      bgColor = const Color.fromRGBO(255, 0, 0, 1.0);
    } else if (number > 30 && number < 41) {
      bgColor = const Color.fromRGBO(0, 0, 0, 1.0);
    } else if (number > 40 && number < 50) {
      bgColor = const Color.fromRGBO(0, 128, 0, 1.0);
    }
    return CircleAvatar(
      minRadius: 17,
      maxRadius: 17,
      backgroundColor: bgColor,
      child: Center(
        child: Text(
          number.toString().padLeft(2, '0'),
          style: TextStyle(
              color: textColor, fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  static Widget paddingL5() {
    return const Padding(
      padding: EdgeInsets.only(left: 5),
    );
  }
  static Widget paddingL10() {
    return const Padding(
      padding: EdgeInsets.only(left: 10),
    );
  }
}
