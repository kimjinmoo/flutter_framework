import 'package:timeago/timeago.dart' as timeago;

class TimeUtils {
  static setLocalMessages() {
    timeago.setLocaleMessages('ko', KoMessages());
  }
  static String timeAgo({milliseconds}) {
    final date = DateTime.fromMillisecondsSinceEpoch(milliseconds);
    return timeago.format(date, locale: "ko");
  }
}

class KoMessages implements timeago.LookupMessages {
  @override
  String prefixAgo() => '';
  @override
  String prefixFromNow() => '';
  @override
  String suffixAgo() => '전';
  @override
  String suffixFromNow() => '후';
  @override
  String lessThanOneMinute(int seconds) => '방금';
  @override
  String aboutAMinute(int minutes) => '방금';
  @override
  String minutes(int minutes) => '$minutes분';
  @override
  String aboutAnHour(int minutes) => '1시간';
  @override
  String hours(int hours) => '$hours시간';
  @override
  String aDay(int hours) => '1일';
  @override
  String days(int days) => '$days일';
  @override
  String aboutAMonth(int days) => '한달';
  @override
  String months(int months) => '$months개월';
  @override
  String aboutAYear(int year) => '1년';
  @override
  String years(int years) => '$years년';
  @override
  String wordSeparator() => ' ';
}
