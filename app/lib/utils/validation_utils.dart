///
/// 욕설,성인 텍스트 체크
/// true : 잘못된 텍스트
/// false : 올바른 텍스트
bool isBlackListCheck(String text) {
  List<String> blackList = "보지,자지,섹스,쌍놈,쌍년,시팔놈,시발년,시발놈,개년,시발년,sex,fuck,니미,씹할년".split(",");
  var list = blackList.where((item)=>text.indexOf(item) > -1);
  if(list.isNotEmpty) {
    return true;
  }
  return false;
}
