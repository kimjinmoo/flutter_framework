///
/// 추첨 번호
///
class MyLottoNumber {
  MyLottoNumber(
      {required this.num1,
        required this.num2,
        required this.num3,
        required this.num4,
        required this.num5,
        required this.num6,
        required this.numEx});

  final int num1;
  final int num2;
  final int num3;
  final int num4;
  final int num5;
  final int num6;
  final int numEx;

  MyLottoNumber.fromJson(Map<String, Object?> json)
      : this(
    num1: json['num1']! as int,
    num2: json['num2']! as int,
    num3: json['num3']! as int,
    num4: json['num4']! as int,
    num5: json['num5']! as int,
    num6: json['num6']! as int,
    numEx: json['numEx']! as int,
  );

  Map<String, Object?> toJson() {
    return {
      'num1': num1,
      'num2': num2,
      'num3': num3,
      'num4': num4,
      'num5': num5,
      'num6': num6,
      'numEx': numEx
    };
  }

  String getWinningNumber() {
    return "${num1.toString().padLeft(2, '0')} ${num2.toString().padLeft(2, '0')} ${num3.toString().padLeft(2, '0')} ${num4.toString().padLeft(2, '0')} ${num5.toString().padLeft(2, '0')} ${num6.toString().padLeft(2, '0')}";
  }

  List<int> toArray() {
    return [
      num1,
      num2,
      num3,
      num4,
      num5,
      num6,
    ];
  }
}
