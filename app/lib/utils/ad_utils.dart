import 'dart:io';

///
/// 광고 ID를 가져온다.
///
String adUnitId() {
  String id = "ca-app-pub-2803985305864806~8892596701";
  if(Platform.isIOS) {
    id = "ca-app-pub-2803985305864806~9084168393";
  }
  return id;
}
