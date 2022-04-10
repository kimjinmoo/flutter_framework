import 'package:flutter_dotenv/flutter_dotenv.dart';

///
/// 환경 변수
///
class Environment {
  static String get fileName => ".env.development";
  static String get apiUrl => dotenv.env['API_URL'] ?? 'MY_FALLBACK';
}
