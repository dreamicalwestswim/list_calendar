
/// 农历数据模型

class Lunar {
  /// 农历年-数字
  int lYear;

  /// 农历月-数字
  int lMonth;

  /// 农历日-数字
  int lDay;

  /// 农历年-中文
  String Animal;

  /// 农历月-中文
  String IMonthCn;

  /// 农历日-中文
  String IDayCn;

  /// 阳历年-数字
  int cYear;

  /// 阳历月-数字
  int cMonth;

  /// 阳历日-数字
  int cDay;

  /// 干支年
  String gzYear;

  /// 干支月
  String gzMonth;

  /// 干支日
  String gzDay;

  /// 是否为今天
  bool isToday;

  /// 是否闰月
  bool isLeap;

  /// 周几-数字
  int nWeek;

  /// 周几-中文
  String ncWeek;

  /// 是否为节气
  bool isTerm;

  /// 24节气
  String? term;

  /// 星座
  String astro;

  Lunar({
    required this.lYear,
    required this.lMonth,
    required this.lDay,
    required this.Animal,
    required this.IMonthCn,
    required this.IDayCn,
    required this.cYear,
    required this.cMonth,
    required this.cDay,
    required this.gzYear,
    required this.gzMonth,
    required this.gzDay,
    required this.isToday,
    required this.isLeap,
    required this.nWeek,
    required this.ncWeek,
    required this.isTerm,
    this.term,
    required this.astro,
  });
}