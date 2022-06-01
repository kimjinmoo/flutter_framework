import 'dart:async';
import 'dart:io';

import 'package:app/pages/accoount/controllers/auth_controller.dart';
import 'package:app/pages/main/domain/entity/commands_model.dart';
import 'package:app/pages/main/domain/entity/user_lotto_model.dart';
import 'package:app/pages/main/domain/entity/winning_number.dart';
import 'package:app/pages/main/domain/rank.dart';
import 'package:app/services/api_service.dart';
import 'package:app/services/firebase_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

///
/// 홈 컨트롤러이다.
/// 홈 기능을 제공한다.
///
class HomeController extends GetxController {
  AuthController authController = Get.find();

  // 프로그레스 true : 처리중, false : 처리완료
  RxBool isProgress = false.obs;

  // 코맨트 컨트럴
  final commentFormKey = GlobalKey<FormState>();
  final commentController = TextEditingController();

  // 댓글 입력 Text
  RxString comment = "".obs;

  // 현 회차 당첨번호
  Rxn<WinningNumber> winningNumberInfo = Rxn<WinningNumber>();
  // 조회 라운드
  RxInt currentRound = 0.obs;
  // 현재 진행중인 회차
  RxInt nextRound = 0.obs;
  // error 여부 true: 에러, false: 정상
  RxBool isError = false.obs;

  // 내 데이터
  Rx<UserLottoModel> myLottoHistory = Rx<UserLottoModel>(UserLottoModel(
    numbers: [],
    round: 0,
    regDate: Timestamp.now(),
    userId: ""
  ));



  @override
  void onInit() async {
    super.onInit();
    // 로딩 시작
    isProgress.value = true;
    // 현재 라운드 초기화
    await fetchCurrentRoundInit().onError((error, stackTrace) => {
          Get.snackbar("경고", "서버에 문제가 발생하였습니다. 잠시후 다시 실행하여 주세요!!"),
          Timer(const Duration(seconds: 10), () {
            if (Platform.isAndroid) {
              SystemNavigator.pop();
            } else if (Platform.isIOS) {
              exit(0);
            }
          })
        });
    // 최신 횟차로 초기화
    await toNextRound();
    // 댓글 업데이트
    commentController.addListener(() {
      comment.value = commentController.text;
    });
    // 최종 프로그레스 false 처리
    if(isProgress.value) {
      isProgress.value = false;
    }
  }

  @override
  void onClose() {
    super.onClose();
    commentController.dispose();
  }

  /// 현재 라운드를 초기화한다.
  Future<void> fetchCurrentRoundInit() async {
    // 승리 번호 히스토리 가져온다.
    WinningNumber? winningNumber = await fetchLottoWinningHistory(null)
        .timeout(const Duration(seconds: 10))
        .catchError((onError) {
      // 에러 체크
      isError.value = true;
      throw Future.error("101 - 서버에 오류가 발생하였습니다.");
    });
    if(winningNumber != null) {
      // 최신 당첨자 발표 회차
      currentRound.value = winningNumber.round;
      // 차주 회차 초기화
      nextRound.value = winningNumber.round + 1;
    }
    // 최신 당첨자 번호
    winningNumberInfo.value = winningNumber;
  }

  ///
  /// 생성된 내 로또 번호 히스토리를 가져온다.
  ///
  Future<void> fetchMyCurrentRoundLottoHistory() async {
    myLottoHistory.value = await fetchMyLotto(currentRound.value, authController.user.value.userId);
  }

  ///
  /// 다음 회차 당첨 번호
  ///
  Future<void> toNextRound() async {
    if (currentRound.value >= nextRound.value) return Future.error("현재 회차가 진행중입니다.");
    isProgress.value = true;
    currentRound.value++;
    // 당첨번호 조회
    winningNumberInfo.value = await fetchLottoWinningHistory(currentRound.value)
        .timeout(const Duration(seconds: 10));
    // 히스토리 가져오기
    await fetchMyCurrentRoundLottoHistory();
    isProgress.value = false;
  }

  ///
  /// 이전 회차 당첨 번호를 설정한다.
  ///
  Future<void> toPreviousRound() async {
    if (currentRound.value < 1) return Future.error("이전 회차가 존재하지 않습니다.");
    isProgress.value = true;
    currentRound.value--;
    // 당첨번호 조회
    winningNumberInfo.value = await fetchLottoWinningHistory(currentRound.value).timeout(const Duration(seconds: 10));
    // 히스토리 가져오기
    await fetchMyCurrentRoundLottoHistory();
    isProgress.value = false;
  }

  ///
  /// 원하는 횟차로 초기화한다.
  ///
  /// [round]에 회차를 입력한다.
  Future<void> setRound(int round) async {
    isProgress.value = true;
    // 현재 라운드
    currentRound.value = round;
    // 당첨번호 조회
    winningNumberInfo.value = await fetchLottoWinningHistory(round);
    // 히스토리 가져오기
    await fetchMyCurrentRoundLottoHistory();
    isProgress.value = false;
  }

  // 코맨트 글을 클리어한다.
  clear() => commentController.clear();

  ///
  /// 코맨트를 추가한다.
  ///
  Future<void> addComment() async {
    // 코맨트를 초기화한다.
    await addCommand(CommandsModel(
            userId: authController.user.value.userId,
            userName: authController.user.value.userName,
            command: commentController.text,
            round: currentRound.value,
            regDate: Timestamp.now()))
        .onError((error, stackTrace) => Future.error("시스템에 문제가 발생하였습니다."));
    // 코맨트를 초기화 한다.
    clear();
  }

  ///
  /// 댓글을 삭제한다.
  ///
  Future<void> removeComment(String id) async {
    await deleteComment(id);
  }

  ///
  /// 댓글 커멘트 라인을 가져온다.
  ///
  int getCommentLine() {
    // 한줄 + 1값을 가져온다.
    int line = '\n'.allMatches(comment.value).length + 1;
    // 최대 라인 3줄로 리턴한다.
    return line > 3 ? 3 : line;
  }

  // 등수를 나타낸다.
  Rank rank(List<int>? numbers) {
    var match = <int>{};
    if (numbers == null) return Rank("진행중", 0);
    // 번호 기준으로 체크 한다.
    for (var i = 0; numbers.length > i; i++) {
      if (winningNumberInfo.value != null) {
        var obj = winningNumberInfo.value?.toArrayNumber().contains(numbers[i]);
        if (obj != null && obj) {
          match.add(numbers[i]);
        }
      }
    }
    // 등수
    switch (match.length) {
      case 6:
        return Rank("1등", 1);
      case 5:
        if (winningNumberInfo.value?.numEx != null &&
            numbers.contains(winningNumberInfo.value?.numEx)) {
          return Rank("2등",2);
        } else {
          return Rank("3등",3);
        }
      case 4:
        return Rank("4등",4);
      case 3:
        return Rank("5등",5);
    }
    return Rank("꽝",-1);
  }
}
