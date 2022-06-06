import 'dart:convert';

import 'package:lotto/pages/home/domain/entity/winning_number.dart';
import 'package:lotto/pages/maker/domain/entity/lotto_number_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

///
/// 당첨 롯또 번호를 가져온다.
///
///
Future<LottoNumberModel> fetchWinningLottoNumbers(List<int> numbers) async {
  var params = {'count': 1, 'numbers': numbers};
  // make url
  var url = Uri.parse('${dotenv.env['API_URL']}/lotto');
  // request
  final response = await http
      .post(url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: json.encode(params))
      .timeout(
    const Duration(seconds: 15),
    onTimeout: () {
      // Time has run out, do what you wanted to do.
      return http.Response(
          'Error', 408); // Request Timeout response status code
    },
  );
  print(response.body);
  if (response.statusCode == 200) {
    List<List<dynamic>> list =
        List.from(List<dynamic>.from(json.decode(response.body)));
    // 현재는 한건씩 처리하는 로직으로 되어 있어 단건씩 넣음
    if (list.isNotEmpty) {
      // result
      LottoNumberModel model = LottoNumberModel.fromJson(
          list[0].map((e) => e.toInt()).toList().toString());
      return model;
    }
    return LottoNumberModel(numbers: [1, 2, 3, 4, 5, 6]);
  }
  return Future.error("서버에 문제가 생겼습니다. 관리자에서 문의하여 주십시요");
}

///
/// AI 롯도 번호를 생성한다.
///
Future fetchAILotto() async {
  var url = Uri.parse('${dotenv.env['API_URL']}/expecter');
  final response = await http.get(url).timeout(
    const Duration(seconds: 10),
    onTimeout: () {
      // Time has run out, do what you wanted to do.
      return http.Response(
          'Error', 408); // Request Timeout response status code
    },
  );
  return response;
}

///
/// 로또 당첨 번호 히스토리 가져오기
///
Future<WinningNumber?> fetchLottoWinningHistory(int? round) async {
  Uri url;
  if (round == null) {
    url = Uri.parse('${dotenv.env['API_URL']}/history');
  } else {
    url = Uri.parse('${dotenv.env['API_URL']}/history?roundNum=$round');
  }

  // request
  final response =
      await http.get(url).timeout(const Duration(seconds: 5), onTimeout: () {
    // Time has run out, do what you wanted to do.
    return http.Response('Error', 408); // Request Timeout response status code
  });
  if (response.statusCode == 200) {
    dynamic obj = jsonDecode(response.body) as List;
    // result
    return WinningNumber.fromJson(obj[0]);
  }
  return null;
}
