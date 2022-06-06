import 'dart:io';

///
/// 광고 ID를 가져온다.
///
String adUnitId() {
  String id = "ca-app-pub-3940256099942544/6300978111";
  if(Platform.isIOS) {
    id = "ca-app-pub-3940256099942544/2934735716";
  }
  return id;
}
