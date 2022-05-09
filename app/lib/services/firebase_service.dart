import 'dart:convert';

import 'package:app/pages/home/domain/entity/commands_model.dart';
import 'package:app/pages/home/domain/entity/user_lotto_model.dart';
import 'package:app/pages/home/domain/entity/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// 파이어베이스
final commandRef = FirebaseFirestore.instance.collection("comments").withConverter<CommandsModel>(
  fromFirestore: (snapshots, _) => CommandsModel.fromJson(snapshots.data()!),
  toFirestore: (command, _) => command.toJson(),
);
final userRef = FirebaseFirestore.instance.collection("user").withConverter<UserModel>(
  fromFirestore: (snapshots, _) => UserModel.fromJson(snapshots.data()!),
  toFirestore: (command, _) => command.toJson(),
);
final userLottoRef = FirebaseFirestore.instance.collection("lotte").withConverter<UserLottoModel>(
  fromFirestore: (snapshots, _) => UserLottoModel.fromJson(snapshots.data()!),
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
  return commandRef.where('round', isEqualTo: round).queryBy(query).snapshots();
}

/// 댓글 추가하기
Future<void> addCommand(commandsModel) async {
  commandRef.add(commandsModel)
      .then((value)=>print(value));
}

/// 댓글 업데이트
Future<void> _updateCommand(widget) async {
  int updated = await FirebaseFirestore.instance
      .runTransaction<int>((transaction) async {
    DocumentSnapshot<CommandsModel> command = await transaction.get<CommandsModel>(widget.reference);
    return 0;
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
  return UserLottoModel(userId: userId, round: round, numbers: const [], regDate: Timestamp.now());
}

///
/// 로또번호 추첨
///
Future<void> addMyLotto(UserLottoModel userLottoModel) async {
  QuerySnapshot<UserLottoModel> querySnapshot = await userLottoRef.where("round", isEqualTo: userLottoModel.round).where("userId", isEqualTo: userLottoModel.userId).get();
  print("addMyLotto");
  if(querySnapshot.docs.isNotEmpty) {
    // ID를 가져온다.
    var id = querySnapshot.docs[0].reference.id;
    // 데이터를 가져온다.
    List<MyLottoNumber> numbers = querySnapshot.docs[0].data().numbers;
    print("data : ${numbers.length}");
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
    print("add!!");
    // 등록된 번호가 없다면 추가
    await userLottoRef.add(userLottoModel);
  }
}
