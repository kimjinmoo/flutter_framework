
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
    isLogin
  });

  // 유저 ID
  final String userId;
  // 유저명
  final String userName;
  // 등록일
  final Timestamp regDate;

  bool isLogin = false;

  // Redirecting 생성자를 통해 생성
  UserModel.fromJson(Map<String, Object?> json)
      : this(
    userId: json['userId']! as String,
    userName: json['userName']! as String,
    regDate: json['regDate']! as Timestamp,
  );

  Map<String, Object?> toJson() {
    return {
      'userId': userId,
      'userName': userName,
      'regDate': regDate
    };
  }
}
