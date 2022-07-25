import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:lotto/pages/account/presentation/controllers/auth_controller.dart';
import 'package:lotto/pages/home/domain/entity/my_lotto_number.dart';
import 'package:lotto/pages/home/domain/entity/user_lotto_model.dart';
import 'package:lotto/pages/maker/domain/lotto_number.dart';
import 'package:lotto/services/api_service.dart';
import 'package:lotto/services/firebase_service.dart';
import 'package:lotto/utils/ad_utils.dart';

///
/// 번호 생성 컨트롤러
///
class MakerController extends GetxController {
  AuthController _authController = Get.find();

  // 광고 설정
  Rxn<BannerAd> _bannerAd = Rxn<BannerAd>();

  // 광고
  RxBool isAdError = true.obs;

  // 광고 가져오기
  BannerAd? get bannerAd => _bannerAd.value;

  // 번호
  RxSet<int> number = <int>{}.obs;

  // 생성 카운트
  RxInt count = 1.obs;

  // 생성한 번호
  RxList<MyLottoNumber> createLotto = <MyLottoNumber>[].obs;

  // 프로세스 여부 true 처리중, false 처리완료
  RxBool isProcess = false.obs;

  @override
  void onInit() {
    super.onInit();
    adInit();
  }

  @override
  void dispose() {
    _bannerAd.value?.dispose();
  }

  void adInit() {
    // 광고 리스터 생성
    final BannerAdListener listener = BannerAdListener(
      // Called when an ad is successfully received.
      onAdLoaded: (Ad ad) => isAdError.value = false,
      // Called when an ad request failed.
      onAdFailedToLoad: (Ad ad, LoadAdError error) {
        // Dispose the ad here to free resources
        ad.dispose();
        isAdError.value = true;
      },
      // Called when an ad opens an overlay that covers the screen.
      onAdOpened: (Ad ad) => print('Ad opened.'),
      // Called when an ad removes an overlay that covers the screen.
      onAdClosed: (Ad ad) => print('Ad closed.'),
      // Called when an impression occurs on the ad.
      onAdImpression: (Ad ad) => print('Ad impression.'),
    );
    // Admob 광고
    _bannerAd.value = BannerAd(
        adUnitId: adUnitId(),
        size: AdSize.banner,
        request: const AdRequest(),
        listener: listener);
    // 광고 로딩
    _bannerAd.value?.load();
  }

  ///
  /// 탭이벤트 처리
  ///
  void onTapNumber(int number) {
    if (this.number.contains(number)) {
      this.number.value.remove(number);
    } else {
      if (this.number.value.length < 6) {
        this.number.value.add(number);
      }
    }
    this.number.refresh();
  }

  ///
  /// 횟수를 저장한다.
  ///
  void onChangeCount(int value) {
    count.value = value;
  }

  void checkTime() {
    final now = DateTime.now(); //반드시 다른 함수에서 해야함, Mypage같은 클래스에서는 사용 불가능
    final testDay = DateTime(now.year, now.month, now.day, 20, 30);
    final startDay = DateTime(now.year, now.month, now.day, 20, 30);
    final stopDay = DateTime(now.year, now.month, now.day, 20, 45);
    if (now.weekday == 1 && now.compareTo(startDay) >= 0) {
      if (startDay.difference(stopDay).inMinutes > 0) {
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
  Future<void> createNumbers(int round, List<int> numbers, int count) async {
    isProcess.value = true;
    // 리스트 초기화
    createLotto.value = [];
    // 등록된 번호 리스트
    List<MyLottoNumber> lottoNumbers = [];
    try {
      // 번호 가져오기
      LottoNumber createdNumbers =
          await fetchWinningLottoNumbers(count, numbers);
      if (createdNumbers.lottoModels.isNotEmpty) {
        // 추출한 번호를 DB에 저장한다.
        createdNumbers.lottoModels.forEach((element) {
          MyLottoNumber number = MyLottoNumber(
              num1: element.numbers[0],
              num2: element.numbers[1],
              num3: element.numbers[2],
              num4: element.numbers[3],
              num5: element.numbers[4],
              num6: element.numbers[5],
              numEx: 0);
          lottoNumbers.add(number);
        });
        await addMyLotto(
          UserLottoModel(
            userId: _authController.user.value.userId,
            round: round,
            numbers: lottoNumbers,
            maxRank: _authController.user.value.maxRank,
            regDate: Timestamp.now(),
          ),
        ).onError((error, stackTrace) => print(error));
      }
    } catch (e) {
      throw Future.error(e.toString());
    } finally {
      // 초기화
      number.value = {};
      // 생성 데이터 Set
      createLotto.value = lottoNumbers;
      // 생성 카운트 초기화
      this.count.value = 1;
      // 프로세스 종료
      isProcess.value = false;
    }
  }

  /// 번호 삭제
  Future<void> deleteNumber(int round, int numberIndex) async {
    isProcess.value = true;
    try {
      await deleteMyLotto(
          round, _authController.user.value.userId, numberIndex);
    } catch (e) {
      throw Future.error(e.toString());
    } finally {
      isProcess.value = false;
    }
  }

  /// 선택 클리어
  void clear() {
    // 초기화
    number.value = {};
    // 생성 데이터 Set
    createLotto.value = [];
  }

  ///
  /// 수동으로 선택한 번호를 리턴한다.
  ///
  List<int> getValues() {
    List<int> values = [];

    for (int idx = 0; idx < number.value.length; idx++) {
      values.add(number.value.elementAt(idx));
    }
    // 정렬
    values.sort();
    return values;
  }

  ///
  /// 현재 뽑기 모드
  ///
  String getMode() {
    if (number.length > 0 && number.length < 6) {
      return "반자동";
    }
    if (number.length == 6) {
      return "수동";
    }
    return "자동";
  }

  ///
  /// 진행 Set
  ///
  void setProgress(bool isProgress) {
    this.isProcess.value = isProgress;
  }
}
