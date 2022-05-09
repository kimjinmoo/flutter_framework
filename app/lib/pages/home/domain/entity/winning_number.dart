///
/// 로또 번호 가져오기
///
class WinningNumber {
  WinningNumber(
      {required this.num1,
      required this.num2,
      required this.num3,
      required this.num4,
      required this.num5,
      required this.num6,
      required this.numEx,
      required this.rank1pay,
      required this.rank2pay,
      required this.rank3pay,
      required this.rank4pay,
      required this.rank5pay,
      required this.round,
      required this.winners1,
      required this.winners2,
      required this.winners3,
      required this.winners4,
      required this.winners5});

  final int num1;
  final int num2;
  final int num3;
  final int num4;
  final int num5;
  final int num6;
  final int numEx;
  final int rank1pay;
  final int rank2pay;
  final int rank3pay;
  final int rank4pay;
  final int rank5pay;
  final int round;
  final int winners1;
  final int winners2;
  final int winners3;
  final int winners4;
  final int winners5;

  String getWinningNumber() {
    return "${this.num1.toString().padLeft(2, '0')} ${this.num2.toString().padLeft(2, '0')} ${this.num3.toString().padLeft(2, '0')} ${this.num4.toString().padLeft(2, '0')} ${this.num5.toString().padLeft(2, '0')} ${this.num6.toString().padLeft(2, '0')} + ${this.numEx.toString().padLeft(2, '0')}";
  }

  // Redirecting 생성자를 통해 생성
  WinningNumber.fromJson(Map<String, Object?> json)
      : this(
          num1: json['num_1']! as int,
          num2: json['num_2']! as int,
          num3: json['num_3']! as int,
          num4: json['num_4']! as int,
          num5: json['num_5']! as int,
          num6: json['num_6']! as int,
          numEx: json['num_ex']! as int,
          rank1pay: json['paid_1']! as int,
          rank2pay: json['paid_2']! as int,
          rank3pay: json['paid_3']! as int,
          rank4pay: json['paid_4']! as int,
          rank5pay: json['paid_5']! as int,
          round: json['round']! as int,
          winners1: json['winners_1']! as int,
          winners2: json['winners_2']! as int,
          winners3: json['winners_3']! as int,
          winners4: json['winners_4']! as int,
          winners5: json['winners_5']! as int,
        );
}
