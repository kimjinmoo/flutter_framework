import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

///
/// 댓글 모델
///
@immutable
class UserModel {
  // 생성자
  UserModel({
    required this.userId,
    required this.userName,
    required this.regDate,
    required this.maxRank,
    required this.privacyAgreementYn,
    isLogin,
  });

  // 유저 ID
  final String userId;

  // 유저명
  final String userName;

  // 등록일
  final Timestamp regDate;

  // 최대 당첨 등급
  final int maxRank;

  // 개인정보 동의
  final String privacyAgreementYn;

  bool isLogin = false;

  // Redirecting 생성자를 통해 생성
  UserModel.fromJson(Map<String, Object?> json)
      : this(
            userId: json['userId']! as String,
            userName: json['userName']! as String,
            regDate: json['regDate']! as Timestamp,
            maxRank: (json['maxRank'] ??= 0) as int,
            privacyAgreementYn: (json['privacyAgreementYn'] ??= "N") as String
  );

  Map<String, Object?> toJson() {
    return {
      'userId': userId,
      'userName': userName,
      'regDate': regDate,
      'maxRank': maxRank,
      'privacyAgreementYn': privacyAgreementYn
    };
  }
}
