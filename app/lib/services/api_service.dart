import 'dart:convert';

import 'package:app/pages/home/domain/entity/lotto_number_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

///
/// 당첨 롯또 번호를 가져온다.
///
///
Future<LottoNumberModel> fetchWinningLottoNumbers(List<int> numbers) async {
  // set parameter
  String payload = json.encode(numbers);
  // make url
  var url = Uri.parse('${dotenv.env['API_URL']}/lotto');
  // request
  final response = await http.post(url, body: payload);
  if(response.statusCode == 200) {
    // result
    return LottoNumberModel.fromJson(response.body);
  }
  return Future.error("서버에 문제가 생겼습니다. 관리자에서 문의하여 주십시요");
}

///
/// AI 롯도 번호를 생성한다.
///
Future fetchAILotto() async {
  var url = Uri.parse('${dotenv.env['API_URL']}/expecter');
  final response = await http.get(url);
  return response;
}

///
/// 댓글을 조회한다.
///
Future fetchCommand() async {
  var url = Uri.parse('${dotenv.env['API_URL']}/social');
}
