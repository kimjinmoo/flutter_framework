import 'dart:convert';

import 'package:lotto/pages/maker/domain/entity/lotto_number_model.dart';

class LottoNumber {
  LottoNumber({required this.lottoModels});

  final List<LottoNumberModel> lottoModels;

  // JSON 모델을 객체로 변경
  factory LottoNumber.fromJson(jsonString) => LottoNumber(
      lottoModels: List<LottoNumberModel>.from(json.decode(jsonString))
  );

  // JSON으로 변경
  Map<String, List<Map<String, Object?>>> toJson() {
    return {
      "numbers": lottoModels.map((e) => e.toJson()).toList()
    };
  }
}
