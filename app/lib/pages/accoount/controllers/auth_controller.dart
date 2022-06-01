import 'package:app/pages/main/domain/entity/user_model.dart';
import 'package:app/services/firebase_service.dart';
import 'package:app/utils/random_nickname_makers.dart';
import 'package:app/utils/share_utils.dart';
import 'package:app/utils/time_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class AuthController extends GetxController {
  // 기본 유저 모델
  Rx<UserModel> user = UserModel(userId: "", userName: "", regDate: Timestamp.now()).obs;
  // 유저명
  RxString userName = "".obs;
  // 프로그레스 true : 처리중, false : 처리완료
  RxBool isProgress = false.obs;

  @override
  void onInit() {
    super.onInit();
    // 시간 설정
    TimeUtils.setLocalMessages();
    // 유저 초기화
    userInit();
  }

  ///
  /// 유저를 생성한다.
  ///
  userInit() async {
    String? userKey = await readAsString("userKey");
    if (userKey == null) {
      // null인경우 저장한다.
      // 유저명
      userKey = const Uuid().v4();
      saveAsString("userKey", userKey);
    }
    UserModel? userModel = await getUser(userKey);
    if (userModel == null) {
      userModel = UserModel(
          userId: userKey, userName: getNickName(), regDate: Timestamp.now());
      addUser(userModel);
    }
    // 로그인 처리
    userModel.isLogin = true;
    // 유저
    user.value = userModel;
    // 유저명
    userName.value = userModel.userName;
  }

  /// 유저명을 업데이트 한다.
  Future<void> changeUserName(String userName) async {
    if (userName.isNotEmpty) {
      isProgress.value = true;
      UserModel updatedUser = await updateUserName(user.value.userId, userName);
      this.userName.value = updatedUser.userName;
      isProgress.value = false;
    }
  }
}
