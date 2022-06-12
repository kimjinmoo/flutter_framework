import 'dart:convert';

import 'package:lotto/pages/home/domain/entity/commands_model.dart';
import 'package:lotto/pages/home/domain/entity/my_lotto_number.dart';
import 'package:lotto/pages/home/domain/entity/report_model.dart';
import 'package:lotto/pages/account/domain/entity/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lotto/pages/home/domain/entity/user_lotto_model.dart';

// 파이어베이스
final commandRef = FirebaseFirestore.instance.collection("comments").withConverter<CommandsModel>(
  fromFirestore: (snapshots, _) => CommandsModel.fromJson(snapshots.data()!),
  toFirestore: (command, _) => command.toJson(),
);
final userRef = FirebaseFirestore.instance.collection("user").withConverter<UserModel>(
  fromFirestore: (snapshots, _) => UserModel.fromJson(snapshots.data()!),
  toFirestore: (command, _) => command.toJson(),
);
final userLottoRef = FirebaseFirestore.instance.collection("lotto").withConverter<UserLottoModel>(
  fromFirestore: (snapshots, _) => UserLottoModel.fromJson(snapshots.data()!),
  toFirestore: (command, _) => command.toJson(),
);

final reportRef = FirebaseFirestore.instance.collection("report").withConverter<ReportModel>(
  fromFirestore: (snapshots, _) => ReportModel.fromJson(snapshots.data()!),
  toFirestore: (command, _) => command.toJson(),
);
enum CommandsQuery {
  createDateAsc,
  createDateDesc
}

// extension 기능 (기존 class 재정의)
extension on Query<CommandsModel> {
  Query<CommandsModel> queryBy(CommandsQuery query) {
    switch (query) {
      case CommandsQuery.createDateAsc:
      case CommandsQuery.createDateDesc:
        return orderBy('regDate', descending: query == CommandsQuery.createDateDesc);
    }
  }
}

/// 댓글 조회하기
Stream<QuerySnapshot<CommandsModel>> getFirebaseInstance(query, round) {
  return commandRef.where('round', isEqualTo: round).where('isReport', isEqualTo: "N").queryBy(query).snapshots();
}

///
/// 유저를 업데이트한다.
///
/// [userId]는 필수값이다.
/// [userName]은 변경될 유저 명이다.
Future<UserModel> updateUserName(String userId, String userName) async {
  QuerySnapshot<UserModel> user = await userRef.where("userId", isEqualTo: userId).get();
  if(user.docs.isNotEmpty) {
    // 유저명 변경
    UserModel userModel = user.docs.first.data();
    UserModel updatedUserModel = UserModel(userId: userModel.userId, userName: userName, regDate: userModel.regDate);
    userRef.doc(user.docs.first.reference.id).set(updatedUserModel);
    // 코맨트명 변경
    QuerySnapshot<CommandsModel> commands = await commandRef.where("userId", isEqualTo: userId).get();
    if(commands.docs.isNotEmpty) {
      commands.docs.forEach((element) {
        CommandsModel command = element.data();
        commandRef.doc(element.reference.id).set(CommandsModel(
            userId: command.userId,
            userName: updatedUserModel.userName,
            command: command.command,
            isReport: command.isReport,
            round: command.round,
            regDate: command.regDate));
      });
    }
    return updatedUserModel;
  }
  throw Future.error("없는 유저입니다,");
}

/// 댓글 추가하기
Future<void> addCommand(commandsModel) async {
  commandRef.add(commandsModel)
      .then((value)=>print(value));
}

/// 댓글 업데이트
Future<void> updateCommand(widget) async {
  int updated = await FirebaseFirestore.instance
      .runTransaction<int>((transaction) async {
    DocumentSnapshot<CommandsModel> command = await transaction.get<CommandsModel>(widget.reference);
    return 0;
    });
}

/// 댓글을 삭제한다.
Future<void> deleteComment(id) async {
  await commandRef.doc(id).delete();
}

// 댓글을 신고한다.
Future<void> reportComment(id) async {
  return commandRef
      .doc(id)
      .update({
    'isReport': "Y"
  });
}

// 유저값을 가져온다.
Future<UserModel?> getUser(String id) async {
  QuerySnapshot<UserModel> querySnapshot = await userRef.where("userId", isEqualTo: id).get();
  final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
  return allData.isEmpty?null:allData.first;
}

/// 댓글 추가하기
Future<void> addUser(UserModel userModel) async {
  userRef.add(userModel)
      .then((value)=>print(value));
}

/// 내 추천점호를 가져온다.
Future<UserLottoModel> fetchMyLotto(int round, String userId) async {
  QuerySnapshot<UserLottoModel> querySnapshot = await userLottoRef.where("round", isEqualTo: round).where("userId", isEqualTo: userId).get();
  if(querySnapshot.docs.isNotEmpty) {
    return querySnapshot.docs.first.data();
  }
  return UserLottoModel(
      numbers: [],
      round: 0,
      regDate: Timestamp.now(),
      userId: ""
  );
}

/// 내 추첨번호를 제거한다.
Future<void> deleteMyLotto(int round, String userId, int removeIndex) async {
  QuerySnapshot<UserLottoModel> querySnapshot = await userLottoRef.where("round", isEqualTo: round).where("userId", isEqualTo: userId).get();
  if(querySnapshot.docs.isNotEmpty) {
    var id = querySnapshot.docs[0].reference.id;
    print(id);
    List<MyLottoNumber> numbers = querySnapshot.docs[0].data().numbers;
    print(numbers.length);
    if(!numbers.isEmpty) {
      // 데이터를 삭제한다.
      numbers.removeAt(removeIndex);
      // 데이터를 업데이트 한다.
      userLottoRef.doc(id).update({'numbers': numbers.map((e)=>e.toJson()).toList()});
    }
  }
}

///
/// 로또번호 추첨
///
Future<void> addMyLotto(UserLottoModel userLottoModel) async {
  QuerySnapshot<UserLottoModel> querySnapshot = await userLottoRef.where("round", isEqualTo: userLottoModel.round).where("userId", isEqualTo: userLottoModel.userId).get();
  if(querySnapshot.docs.isNotEmpty) {
    // ID를 가져온다.
    var id = querySnapshot.docs[0].reference.id;
    // 데이터를 가져온다.
    List<MyLottoNumber> numbers = querySnapshot.docs[0].data().numbers;
    if(!numbers.isNotEmpty) {
      // 등록된 번호가 없다면 추가
      await userLottoRef.add(userLottoModel);
    } else {
      for(MyLottoNumber number in userLottoModel.numbers) {
        // 번호를 추가한다.
        numbers.add(number);
      }
      // 업데이트
      userLottoRef.doc(id).update({'numbers': numbers.map((e) => e.toJson()).toList()});
    }
  } else {
    // 등록된 번호가 없다면 추가
    await userLottoRef.add(userLottoModel);
  }
}
