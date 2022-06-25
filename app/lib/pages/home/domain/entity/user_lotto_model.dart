import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import 'my_lotto_number.dart';

///
/// 댓글 모델
///
@immutable
class UserLottoModel {
  // 생성자
  UserLottoModel(
      {required this.userId,
      required this.round,
      required this.numbers,
      required this.maxRank,
      required this.regDate});

  // 유저 ID
  final String userId;

  // 유저명
  final int round;

  // 로또 번호
  final List<MyLottoNumber> numbers;

  // 등록일
  final Timestamp regDate;

  final int maxRank;

  // Redirecting 생성자를 통해 생성
  UserLottoModel.fromJson(Map<String, Object?> json)
      : this(
          userId: json['userId']! as String,
          round: json['round']! as int,
          numbers: (json['numbers']! as List)
              .map((i) => MyLottoNumber.fromJson(i))
              .toList(),
          maxRank: (json['maxRank']??0) as int,
          regDate: json['regDate']! as Timestamp,
        );

  Map<String, Object?> toJson() {
    return {
      'userId': userId,
      'round': round,
      'numbers': numbers.map((e) => e.toJson()).toList(),
      'maxRank': maxRank,
      'regDate': regDate
    };
  }
}
