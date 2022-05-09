
import 'dart:math';

/// 닉네임을 가져온다.
String getNickName () {
  List<String> nickName = [
    "꼴뚜기","망고","브라이언","사과","함박",
    "망자","사시미","꼬마","여름이","가을이",
    "망령","고구마","두루마리","여행가","사슴이"
  ];

  return nickName[Random().nextInt(nickName.length)];
}

