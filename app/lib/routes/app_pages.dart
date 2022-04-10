import 'package:app/pages/home/presentation/views/home_view.dart';
import 'package:app/pages/home/presentation/views/maker_view.dart';
import 'package:app/pages/home/presentation/views/qrcode_view.dart';
import 'package:app/pages/home/presentation/views/week_view.dart';
import 'package:app/pages/side/presentation/about_view.dart';
import 'package:app/pages/side/presentation/history_view.dart';
import 'package:get/get.dart';

part './app_routes.dart';

class AppPages {
  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: Routes.HOME,
      page: () => Home(),
      children: [
        GetPage(
            name: Routes.HOME_QRCODE,
            page: () => QrCode(),
            transition: Transition.rightToLeft),
        GetPage(
            name: Routes.HOME_MAKER,
            page: () => Maker(),
            transition: Transition.downToUp),
        GetPage(
            name: Routes.HOME_WEEK,
            page : ()=> Week(),
            transition: Transition.zoom
        )
      ],
    ),
    GetPage(
        name: Routes.SIDE,
        page: () => History(),
        children: [
          GetPage(name: Routes.SIDE_HISTORY, page: () => History(), transition: Transition.rightToLeft),
          GetPage(name: Routes.SIDE_ABOUT, page: ()=>About(), transition: Transition.rightToLeft)
        ])
  ];
}
