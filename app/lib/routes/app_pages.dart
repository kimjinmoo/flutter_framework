import 'package:lotto/pages/home/presentation/views/home_view.dart';
import 'package:lotto/pages/home/presentation/views/landing_view.dart';
import 'package:lotto/pages/info/presentation/views/status_view.dart';
import 'package:lotto/pages/info/presentation/views/total_status_view.dart';
import 'package:lotto/pages/setting/presentation/views/about_view.dart';
import 'package:lotto/pages/setting/presentation/views/account_setting_view.dart';
import 'package:lotto/pages/setting/presentation/views/qna_view.dart';
import 'package:get/get.dart';

part './app_routes.dart';

class AppPages {
  static const INITIAL = Routes.MAIN;

  static final routes = [
    GetPage(
      name: Routes.MAIN,
      page: () => LandingView()
    ),
    GetPage(
      name: Routes.HOME,
      page: () => Home()
    ),
    GetPage(name: Routes.STATUS, page: ()=>LottoStatisticsWebview(),transition: Transition.rightToLeft),
    GetPage(name: Routes.TOTAL_STATUS, page: ()=>LottoTotalStatisticsWebview(),transition: Transition.rightToLeft),
    GetPage(name: Routes.ACCOUNT, page: ()=>AccountSetting(), transition: Transition.rightToLeft),
    GetPage(name: Routes.SIDE_QNA, page: ()=>QnaWebview(), transition: Transition.rightToLeft),
    GetPage(name: Routes.SIDE_ABOUT, page: ()=>About(), transition: Transition.rightToLeft),
  ];
}
