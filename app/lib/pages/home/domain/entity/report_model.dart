import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

///
/// 댓글 모델
///
@immutable
class ReportModel {
  // 생성자
  ReportModel({
    required this.commentId,
    required this.type,
  });

  // 유저 ID
  final String commentId;

  // 등록일
  final int type;

  // Redirecting 생성자를 통해 생성
  ReportModel.fromJson(Map<String, Object?> json)
      : this(
            commentId: json['commentId']! as String,
            type: json['type']! as int);

  Map<String, Object?> toJson() {
    return {
      'commentId': commentId,
      'type': type,
    };
  }
}
