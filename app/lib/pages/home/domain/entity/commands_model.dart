import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

///
/// 댓글 모델
///
@immutable
class CommandsModel {
  // 생성자
  CommandsModel(
      {required this.userId,
      required this.userName,
      required this.command,
      required this.isReport,
      this.likeIt = 0,
      required this.round,
      required this.regDate});

  // 유저 ID
  final String userId;

  // 유저명
  final String userName;

  // 댓글
  final String command;

  // 신고 여부 Y: 신고, N 미신고
  final String isReport;

  // 좋아요 카운트
  final int likeIt;

  // 회차
  final int round;

  // 등록일
  final Timestamp regDate;

  // Redirecting 생성자를 통해 생성
  CommandsModel.fromJson(Map<String, Object?> json)
      : this(
          userId: json['userId']! as String,
          userName: json['userName']! as String,
          command: json['command']! as String,
          isReport:
              json['isReport'] == null ? "N" : json['isReport']! as String,
          likeIt: json['likeIt']! as int,
          round: json['round']! as int,
          regDate: json['regDate']! as Timestamp,
        );

  Map<String, Object?> toJson() {
    return {
      'userId': userId,
      'userName': userName,
      'command': command,
      'isReport': isReport,
      'likeIt': likeIt,
      'round': round,
      'regDate': regDate
    };
  }
}
