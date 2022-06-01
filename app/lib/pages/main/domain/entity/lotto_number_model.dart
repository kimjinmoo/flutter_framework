import 'dart:convert';

///
/// 로또번호 생성 결과
///
class LottoNumberModel{
  LottoNumberModel({required this.numbers});

  final List<int> numbers;

  ///
  /// Json을 모델로 변환
  ///
  /// factory 사용 장점
  /// 기존에 이미 생성된 인스턴스가 있다면 return 하여 재사용.
  /// 하나의 클래스에서 하나의 인스턴스만 생성한다(싱글톤 패턴).
  /// 서브 클래스 인스턴스를 리턴할 때 사용할 수 있다.
  /// Factory constructors 에서는 this 에 접근할 수 없다.
  factory LottoNumberModel.fromJson(jsonString) => LottoNumberModel(
    numbers: List<int>.from(json.decode(jsonString))
  );

  Map<String, Object?> toJson() {
    return {
      'num1': numbers[0],
      'num2': numbers[1],
      'num3': numbers[2],
      'num4': numbers[3],
      'num5': numbers[4],
      'num6': numbers[5],
      'numEx': 0
    };
  }
}
