import 'package:app/pages/home/domain/entity/commands_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// 파이어베이스
final commandRef = FirebaseFirestore.instance.collection("comments").withConverter<CommandsModel>(
  fromFirestore: (snapshots, _) => CommandsModel.fromJson(snapshots.data()!),
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

Stream<QuerySnapshot<CommandsModel>> getFirebaseInstance(query, round) {
  return commandRef.where('round', isEqualTo: round).queryBy(query).snapshots();
}

Future<void> addCommand(round, command) async {
  print("addCommand!!");
  commandRef.add(CommandsModel(userId: "test", userName: "test", command: command, round: round, regDate: Timestamp.now()))
      .then((value)=>print(value));
}

Future<void> _updateCommand(widget) async {
  int updated = await FirebaseFirestore.instance
      .runTransaction<int>((transaction) async {
    DocumentSnapshot<CommandsModel> command = await transaction.get<CommandsModel>(widget.reference);
    return 0;
    });
}
