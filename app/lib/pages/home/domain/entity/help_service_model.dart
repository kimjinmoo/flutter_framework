import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

///
/// 유저 신고하기 모델
///
@immutable
class HelpServiceModel {
  // 생성자
  HelpServiceModel({
    required this.contents,
    required this.subject,
    required this.type,
  });

  // 내용
  final String contents;

  // 제목
  final String subject;

  // 타입, 로또는 3
  final int type;

  // Redirecting 생성자를 통해 생성
  HelpServiceModel.fromJson(Map<String, Object?> json)
      : this(
            contents: json['contents']! as String,
            subject: json['subject'] as String,
            type: json['type']! as int);

  Map<String, Object?> toJson() {
    return {
      'contents': contents,
      'subject': subject,
      'type': type,
    };
  }
}
