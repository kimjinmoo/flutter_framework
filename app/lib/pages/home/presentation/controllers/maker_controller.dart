import 'package:app/pages/home/domain/entity/lotto_number_model.dart';
import 'package:app/pages/home/domain/entity/user_lotto_model.dart';
import 'package:app/services/api_service.dart';
import 'package:app/services/firebase_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

///
/// 번호 생성 컨트롤러
///
class MakerController extends GetxController {
  // 번호
  RxList<int> number = [1, 2, 3, 4, 5, 6].obs;
  // 자동 여부 true 자동, false 수동
  RxList<bool> numAutos = [true, true, true, true, true, true].obs;
  // 생성 카운트
  RxInt count = 1.obs;
  // 프로세스 여부 true 처리중, false 처리완료
  RxBool isProcess = false.obs;
  // 유효성 여부 false 정상, true 비정상
  RxBool isValid = false.obs;
  @override
  void onInit() {
    super.onInit();
  }

  ///
  /// 수동입력번호를 선택한다.
  ///
  void onChangeValue(int idx, int num, int minValue, int maxValue) {
    int checkNumber = num;
    // 최대값을 초과 하면 최소값으로 변경한다.
    if (checkNumber > maxValue) {
      checkNumber = minValue;
    }
    number[idx] = checkNumber;
  }

  ///
  /// 횟수를 저장한다.
  ///
  void onChangeCount(int value) {
    count.value = value;
  }

  ///
  /// 중복된 번호를 체크한다.
  ///
  void onCheckLottoNumber() {
    var data = Set();
    int real = 0;
    for (var idx = 0; idx < numAutos.value.length; idx++) {
      print(numAutos.value[idx]);
      if(!numAutos.value[idx]) {
        real++;
        data.add(number.value[idx]);
      }
    }
    if(real == data.length) {
      isValid.value = true;
    } else {
      isValid.value = false;
    }
  }

  ///
  /// 자동/수동 상태를 저장한다.
  ///
  void onChange(int idx, bool isChecked) {
    numAutos[idx] = isChecked;
  }

  void checkTime() {
    final now = DateTime.now(); //반드시 다른 함수에서 해야함, Mypage같은 클래스에서는 사용 불가능
    print(" now.weekday : ${now.weekday}");
    print(" now.weekday : ${now.hour}");
    print(" now.weekday : ${now.minute}");
    final testDay = DateTime(now.year, now.month, now.day, 20, 30);
    final startDay = DateTime(now.year, now.month, now.day, 20, 30);
    final stopDay = DateTime(now.year, now.month, now.day, 20, 45);
    if(now.weekday == 1 && now.compareTo(startDay) >= 0) {
      // print(now.compareTo(startDay));
      if(startDay.difference(stopDay).inMinutes > 0) {
        throw Exception("초기화");
        return;
      }
    }
  }

  ///
  /// 로또 번호를 생성한다.
  ///
  /// [userId]유저ID 필수값이다.
  /// [round]는 로또의 횟차를 입력한다.
  /// [numbers] 수동값이 필요하다면 값을 배열로 넣는다. ex [1,2,3]
  /// [count]는 회수를 입력한다.
  /// 리턴값은 void이다.
  Future<void> createNumbers(String userId, int round, List<int> numbers, int count) async {
    isProcess.value = true;
    try {
      for(int index = 0; count > index; index++) {
        // 번호 가져오기
        LottoNumberModel model = await fetchWinningLottoNumbers(numbers);
        if(model.numbers.isNotEmpty) {
          await addMyLotto(UserLottoModel(
              userId: userId,
              round: round,
              numbers: [
                MyLottoNumber(
                    num1: model.numbers[0],
                    num2: model.numbers[1],
                    num3: model.numbers[2],
                    num4: model.numbers[3],
                    num5: model.numbers[4],
                    num6: model.numbers[5],
                    numEx: 0)
              ],
              regDate: Timestamp.now())).onError((error, stackTrace) => print(error));
        }
      }
    } catch(e) {
      throw Future.error(e.toString());
    } finally {
      // 초기화
      number.value = [1, 2, 3, 4, 5, 6];
      numAutos.value = [true, true, true, true, true, true];
      this.count.value = 1;
      isProcess.value = false;
    }
  }

  ///
  /// 수동으로 선택한 번호를 리턴한다.
  ///
  List<int> getValues() {
    List<int> values = [];
    for (int idx = 0; idx < numAutos.length; idx++) {
      if (!numAutos[idx]) {
        values.add(number[idx]);
      }
    }
    return values;
  }
}
