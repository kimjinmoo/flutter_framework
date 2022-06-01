import 'package:app/pages/main/presentation/views/home_view.dart';
import 'package:app/pages/main/presentation/views/landing_view.dart';
import 'package:app/pages/main/presentation/views/maker_view.dart';
import 'package:app/pages/main/presentation/views/week_view.dart';
import 'package:app/pages/side/presentation/views/about_view.dart';
import 'package:app/pages/side/presentation/views/account_setting_view.dart';
import 'package:app/pages/side/presentation/views/qna_view.dart';
import 'package:app/pages/side/presentation/views/status_view.dart';
import 'package:get/get.dart';

part './app_routes.dart';

class AppPages {
  static const INITIAL = Routes.MAIN;

  static final routes = [
    GetPage(
      name: Routes.MAIN,
      page: () => LandingView(),
      children: [
        GetPage(
            name: Routes.MAIN_MAKER,
            page: () => Maker(),
            transition: Transition.downToUp),
      ]
    ),
    GetPage(
      name: Routes.HOME,
      page: () => Home(),
      children: [
        GetPage(
            name: Routes.HOME_WEEK,
            page : ()=> Week(),
            transition: Transition.zoom
        )
      ],
    ),
    GetPage(
        name: Routes.SIDE,
        page: () => LottoStatisticsWebview(),
        children: [
          GetPage(name: Routes.SIDE_SETTING, page: () => AccountSetting(), transition: Transition.rightToLeft),
          GetPage(name: Routes.SIDE_STATUS, page: () => LottoStatisticsWebview(), transition: Transition.rightToLeft),
          GetPage(name: Routes.SIDE_QNA, page: ()=>QnaWebview(), transition: Transition.rightToLeft),
          GetPage(name: Routes.SIDE_ABOUT, page: ()=>About(), transition: Transition.rightToLeft),
        ])
  ];
}
