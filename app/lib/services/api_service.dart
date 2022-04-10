import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

///
/// 당첨 롯또 번호를 가져온다.
///
Future fetchWinningLottoNumbers() async {
  var url = Uri.parse('${dotenv.env['API_URL']}/lotto');
  final response = await http.get(url);
  return response;
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
