import 'dart:convert';

///
/// 로또번호 생성 결과
class LottoNumberModel{
  LottoNumberModel({required this.numbers});

  final List<int> numbers;

  ///
  /// Json을 모델로 변환
  ///
  factory LottoNumberModel.fromJson(jsonString) => LottoNumberModel(
    numbers: List<int>.from(json.decode(jsonString))
  );
}
