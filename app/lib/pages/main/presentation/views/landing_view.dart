import 'package:app/pages/main/presentation/controllers/home_controller.dart';
import 'package:app/pages/main/presentation/controllers/landing_controller.dart';
import 'package:app/pages/main/presentation/controllers/maker_controller.dart';
import 'package:app/pages/main/presentation/views/home_view.dart';
import 'package:app/pages/main/presentation/views/maker_view.dart';
import 'package:app/pages/main/presentation/views/setting_view.dart';
import 'package:app/pages/main/presentation/views/week_view.dart';
import 'package:app/pages/side/presentation/views/status_view.dart';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

///
/// 랜딩페이지
///
class LandingView extends GetView<LandingController> {
  final TextStyle unselectedLabelStyle = TextStyle(
      color: Colors.white.withOpacity(0.5),
      fontWeight: FontWeight.w500,
      fontSize: 12);

  final TextStyle selectedLabelStyle =
      TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 12);

  buildBottomNavigationMenu(context, ladingController, homeController, makerController) {
    return Obx(() => BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      showUnselectedLabels: true,
      showSelectedLabels: true,
      onTap: ladingController.changeTabIndex,
      currentIndex: ladingController.tabIndex.value,
      // backgroundColor: Color.fromRGBO(69, 69, 69, 1.0),
      unselectedItemColor: Colors.grey,
      selectedItemColor: Colors.red,
      unselectedLabelStyle: unselectedLabelStyle,
      selectedLabelStyle: selectedLabelStyle,
      items: [
        BottomNavigationBarItem(
          icon: Container(
            margin: EdgeInsets.only(bottom: 7),
            child: Icon(
              Icons.home,
              size: 20.0,
            ),
          ),
          label: '홈',
        ),
        BottomNavigationBarItem(
          icon: Container(
            margin: EdgeInsets.only(bottom: 7),
            child: Badge(
                animationType: BadgeAnimationType.scale,
                badgeColor: Colors.black,
                alignment: Alignment.bottomRight,
                badgeContent: Text(
                    homeController.myLottoHistory.value.numbers
                        .isEmpty
                        ? "0"
                        : "${homeController.myLottoHistory.value.numbers.length}",
                    style: TextStyle(color: Colors.white70)),
                child: const FaIcon(
                  FontAwesomeIcons.rectangleList,
                  size: 24,
                )),
          ),
          label: '내 번호',
        ),
        BottomNavigationBarItem(
          icon: Container(
            height: 50,
            width: 50,
            margin: EdgeInsets.only(bottom: 7),
            child: makerController.isProcess.value?Badge(
              animationType: BadgeAnimationType.scale,
              position: BadgePosition.topEnd(top: -5, end: -5),
              stackFit: StackFit.expand,
              badgeColor: Color.fromRGBO(87, 87, 87, 1.0),
              toAnimate: true,
              badgeContent: Text("...", style: TextStyle(color: Colors.white),),
              child: const Icon(Icons.add_circle_outlined, size: 50, color: Colors.red,),
            ):const Icon(Icons.add_circle_outlined, size: 50, color: Colors.red,)
          ),
          label: 'AI 번호생성',
        ),
        BottomNavigationBarItem(
          icon: Container(
            margin: EdgeInsets.only(bottom: 7),
            child: Icon(
              Icons.bar_chart,
              size: 20.0,
            ),
          ),
          label: '통계',
        ),
        BottomNavigationBarItem(
          icon: Container(
            margin: EdgeInsets.only(bottom: 7),
            child: Icon(
              Icons.settings,
              size: 20.0,
            ),
          ),
          label: '설정',
        ),
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    HomeController homeController = Get.find();
    MakerController makerController = Get.find();
    return Scaffold(
        bottomNavigationBar: Theme(
          data: Theme.of(context).copyWith(canvasColor: Colors.white),
          child: buildBottomNavigationMenu(context, controller, homeController, makerController),
        ),
        body: Obx(
          () => IndexedStack(
            index: controller.tabIndex.value,
            children: [Home(), Week(), Maker(), LottoStatisticsWebview(), Setting()],
          ),
        ));
  }
}
