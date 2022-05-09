import 'package:app/pages/home/domain/entity/commands_model.dart';
import 'package:app/pages/home/domain/entity/user_lotto_model.dart';
import 'package:app/pages/home/domain/entity/user_model.dart';
import 'package:app/pages/home/domain/entity/winning_number.dart';
import 'package:app/services/api_service.dart';
import 'package:app/services/firebase_service.dart';
import 'package:app/utils/random_nickname_makers.dart';
import 'package:app/utils/share_utils.dart';
import 'package:app/utils/time_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

///
/// 홈 컨트롤러이다.
///
class HomeController extends GetxController {
  // 코맨트 컨트럴
  final commentFormKey = GlobalKey<FormState>();
  final commentController = TextEditingController();
  // 댓글 입력 Text
  RxString comment = "".obs;
  // 프로그레스 true : 처리중, false : 처리완료
  RxBool isProgress = false.obs;
  // 현 회차 당첨번호
  RxString roundWinningNumber = "".obs;
  // 조회 라운드
  RxInt round = 0.obs;
  // 현재 진행중인 회차
  RxInt nRound = 0.obs;
  // error 여부 true: 에러, false: 정상
  RxBool isError = false.obs;
  // 유저명
  var userId = "".obs;
  // 유저명
  var userName = "".obs;
  // 내 데이터
  Rx<UserLottoModel> myLotteHistory = Rx<UserLottoModel>(UserLottoModel(
    userId: '',
    round: 0,
    numbers: const <MyLottoNumber>[],
    regDate: Timestamp.now()
  ));
  // 대표 뽑기 번호
  RxString firstNumber = "".obs;

  @override
  void onInit() async {
    super.onInit();
    // 시간 설정
    TimeUtils.setLocalMessages();
    // 현재 라운드 초기화
    await fetchCurrentRoundInit();
    // 유저 초기화
    await userInit();
    // 최신 횟차로 초기화
    await nextRound();
    // 내 추첨번호를 가져온다.
    await fetchCurrentRoundMyLotteHistory();
    // text 업데이트
    commentController.addListener(() {
      comment.value = commentController.text;
    });
    // 스플래시 화면을 종료한다.
    FlutterNativeSplash.remove();
  }

  @override
  void onClose() {
    super.onClose();
    commentController.dispose();
  }

  /// 현재 라운드를 초기화한다.
  Future<void> fetchCurrentRoundInit() async {
    // 승리 번호 히스토리 가져온다.
    WinningNumber winningNumber = await fetchLottoWinningHistory(null).catchError((onError){
      // 에러 체크
      isError.value = true;
      throw Future.error("서버에 오류가 발생하였습니다.");
    });
    // 최신 당첨자 발표 회차
    round.value = winningNumber.round;
    // 최신 당첨자 번호
    roundWinningNumber.value = winningNumber.getWinningNumber();
    // 차주 회차 초기화
    nRound.value = winningNumber.round + 1;
  }

  ///
  /// 추첨번호 히스토리를 가져온다.
  ///
  Future<void> fetchCurrentRoundMyLotteHistory() async {
    UserLottoModel model = await fetchMyLotto(round.value, userId.value);
    if(model.numbers.isNotEmpty) {
      firstNumber.value = model.numbers.first.getWinningNumber();
    }else {
      firstNumber.value = "생성된 번호 없음";
    }
    myLotteHistory.value = model;
  }

  ///
  /// 유저를 생성한다.
  ///
  userInit() async {
    String? userKey = await readAsString("userKey");
    if(userKey == null) {
      // null인경우 저장한다.
      // 유저명
      userKey = const Uuid().v4();
      saveAsString("userKey", userKey);
    }
    UserModel? userModel = await getUser(userKey);
      if(userModel == null) {
      userModel = UserModel(userId: userKey, userName: getNickName(), regDate: Timestamp.now());
      addUser(userModel);
    }
    // 유저명
    userId.value = userModel.userId;
    userName.value = userModel.userName;
  }

  ///
  /// 다음 회차 당첨 번호
  ///
  Future<void> nextRound() async {
    isProgress.value = true;
    round.value++;
    try{
      WinningNumber winningNumber = await fetchLottoWinningHistory(round.value);
      roundWinningNumber.value = winningNumber.getWinningNumber();
    } catch(e) {
      roundWinningNumber.value = "매주 토요일 20시 35분";
    }
    // 히스토리 가져오기
    fetchCurrentRoundMyLotteHistory();
    isProgress.value = false;

  }

  ///
  /// 이전 회차 당첨 번호를 설정한다.
  ///
  Future<void> beforeRound() async {
    isProgress.value = true;
    round.value--;
    try {
      WinningNumber winningNumber = await fetchLottoWinningHistory(round.value);
      roundWinningNumber.value = winningNumber.getWinningNumber();
    } catch(e) {
      if(nRound.value > round.value) {
        roundWinningNumber.value = "없음";
      } else {
        roundWinningNumber.value = "매주 토요일 20시 45분";
      }
    }
    // 히스토리 가져오기
    fetchCurrentRoundMyLotteHistory();
    isProgress.value = false;
  }

  ///
  /// 원하는 횟차로 초기화한다.
  ///
  /// [round]에 회차를 입력한다.
  Future<void> setRound(int round) async {
    isProgress.value = true;
    this.round.value = round;
    try {
      WinningNumber winningNumber = await fetchLottoWinningHistory(round);
      roundWinningNumber.value = winningNumber.getWinningNumber();
    } catch(e) {
      if(nRound.value > round) {
        roundWinningNumber.value = "없음";
      } else {
        roundWinningNumber.value = "매주 토요일 20시 35분";
      }
    } finally {
      // 히스토리 가져오기
      await fetchCurrentRoundMyLotteHistory();
      isProgress.value = false;
    }
  }

  // 코맨트 글을 클리어한다.
  clear() => commentController.clear();

  ///
  /// 코맨트를 추가한다.
  ///
  Future<void> addComment() async {
    // 코맨트를 초기화한다.
    await addCommand(
        CommandsModel(userId: userId.value, userName: userName.value, command: commentController.text, round: round.value, regDate: Timestamp.now())
    ).onError((error, stackTrace) => Future.error("시스템에 문제가 발생하였습니다."));
    // 코맨트를 초기화 한다.
    clear();
  }

  ///
  /// 댓글 커멘트 라인을 가져온다.
  ///
  int getCommentLine() {
    // 한줄 + 1값을 가져온다.
    int line = '\n'.allMatches(comment.value).length + 1;
    // 최대 라인 3줄로 리턴한다.
    return line>3?3:line;
  }
}
