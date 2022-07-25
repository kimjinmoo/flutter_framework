import 'dart:io';

///
/// 광고 ID를 가져온다.
///
String adUnitId() {
  String id = "ca-app-pub-2803985305864806/6401337727";
  if(Platform.isIOS) {
    id = "ca-app-pub-2803985305864806/3392031004";
    // test
    // id = "ca-app-pub-3940256099942544/6300978111";
  }
  return id;
}
