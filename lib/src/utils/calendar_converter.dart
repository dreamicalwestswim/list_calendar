import '../model/lunar.dart';

/// @1900-2100区间内的公历、农历互转
/// @公历转农历：calendar.solar2lunar(1987,11,01); //[you can ignore params of prefix 0]


class CalendarConverter {
  /// 农历1900-2100的润大小信息表
  /// @Array Of Property
  /// @return Hex
  static List<int> lunarInfo = [0x04bd8,0x04ae0,0x0a570,0x054d5,0x0d260,0x0d950,0x16554,0x056a0,0x09ad0,0x055d2,//1900-1909
    0x04ae0,0x0a5b6,0x0a4d0,0x0d250,0x1d255,0x0b540,0x0d6a0,0x0ada2,0x095b0,0x14977,//1910-1919
    0x04970,0x0a4b0,0x0b4b5,0x06a50,0x06d40,0x1ab54,0x02b60,0x09570,0x052f2,0x04970,//1920-1929
    0x06566,0x0d4a0,0x0ea50,0x06e95,0x05ad0,0x02b60,0x186e3,0x092e0,0x1c8d7,0x0c950,//1930-1939
    0x0d4a0,0x1d8a6,0x0b550,0x056a0,0x1a5b4,0x025d0,0x092d0,0x0d2b2,0x0a950,0x0b557,//1940-1949
    0x06ca0,0x0b550,0x15355,0x04da0,0x0a5b0,0x14573,0x052b0,0x0a9a8,0x0e950,0x06aa0,//1950-1959
    0x0aea6,0x0ab50,0x04b60,0x0aae4,0x0a570,0x05260,0x0f263,0x0d950,0x05b57,0x056a0,//1960-1969
    0x096d0,0x04dd5,0x04ad0,0x0a4d0,0x0d4d4,0x0d250,0x0d558,0x0b540,0x0b6a0,0x195a6,//1970-1979
    0x095b0,0x049b0,0x0a974,0x0a4b0,0x0b27a,0x06a50,0x06d40,0x0af46,0x0ab60,0x09570,//1980-1989
    0x04af5,0x04970,0x064b0,0x074a3,0x0ea50,0x06b58,0x055c0,0x0ab60,0x096d5,0x092e0,//1990-1999
    0x0c960,0x0d954,0x0d4a0,0x0da50,0x07552,0x056a0,0x0abb7,0x025d0,0x092d0,0x0cab5,//2000-2009
    0x0a950,0x0b4a0,0x0baa4,0x0ad50,0x055d9,0x04ba0,0x0a5b0,0x15176,0x052b0,0x0a930,//2010-2019
    0x07954,0x06aa0,0x0ad50,0x05b52,0x04b60,0x0a6e6,0x0a4e0,0x0d260,0x0ea65,0x0d530,//2020-2029
    0x05aa0,0x076a3,0x096d0,0x04afb,0x04ad0,0x0a4d0,0x1d0b6,0x0d250,0x0d520,0x0dd45,//2030-2039
    0x0b5a0,0x056d0,0x055b2,0x049b0,0x0a577,0x0a4b0,0x0aa50,0x1b255,0x06d20,0x0ada0,//2040-2049
    /**Add By JJonline@JJonline.Cn**/
    0x14b63,0x09370,0x049f8,0x04970,0x064b0,0x168a6,0x0ea50, 0x06b20,0x1a6c4,0x0aae0,//2050-2059
    0x0a2e0,0x0d2e3,0x0c960,0x0d557,0x0d4a0,0x0da50,0x05d55,0x056a0,0x0a6d0,0x055d4,//2060-2069
    0x052d0,0x0a9b8,0x0a950,0x0b4a0,0x0b6a6,0x0ad50,0x055a0,0x0aba4,0x0a5b0,0x052b0,//2070-2079
    0x0b273,0x06930,0x07337,0x06aa0,0x0ad50,0x14b55,0x04b60,0x0a570,0x054e4,0x0d160,//2080-2089
    0x0e968,0x0d520,0x0daa0,0x16aa6,0x056d0,0x04ae0,0x0a9d4,0x0a2d0,0x0d150,0x0f252,//2090-2099
    0x0d520];

  /// 公历每个月份的天数普通表
  /// @Array Of Property
  /// @return Number
  static List<int> solarMonth = [31,28,31,30,31,30,31,31,30,31,30,31];

  /// 天干地支之天干速查表
  /// @Array Of Property trans["甲","乙","丙","丁","戊","己","庚","辛","壬","癸"]
  /// @return Cn string
  static List<String> Gan = ["\u7532","\u4e59","\u4e19","\u4e01","\u620a","\u5df1","\u5e9a","\u8f9b","\u58ec","\u7678"];

  /// 天干地支之地支速查表
  /// @Array Of Property
  /// @trans["子","丑","寅","卯","辰","巳","午","未","申","酉","戌","亥"]
  /// @return Cn string
  static List<String> Zhi = ["\u5b50","\u4e11","\u5bc5","\u536f","\u8fb0","\u5df3","\u5348","\u672a","\u7533","\u9149","\u620c","\u4ea5"];

  /// 天干地支之地支速查表<=>生肖
  /// @Array Of Property
  /// @trans["鼠","牛","虎","兔","龙","蛇","马","羊","猴","鸡","狗","猪"]
  /// @return Cn string
  static List<String> Animals = ["\u9f20","\u725b","\u864e","\u5154","\u9f99","\u86c7","\u9a6c","\u7f8a","\u7334","\u9e21","\u72d7","\u732a"];

  /// 24节气速查表
  /// @Array Of Property
  /// @trans["小寒","大寒","立春","雨水","惊蛰","春分","清明","谷雨","立夏","小满","芒种","夏至","小暑","大暑","立秋","处暑","白露","秋分","寒露","霜降","立冬","小雪","大雪","冬至"]
  /// @return Cn string
  static List<String> solarTerm = ["\u5c0f\u5bd2","\u5927\u5bd2","\u7acb\u6625","\u96e8\u6c34","\u60ca\u86f0","\u6625\u5206","\u6e05\u660e","\u8c37\u96e8","\u7acb\u590f","\u5c0f\u6ee1","\u8292\u79cd","\u590f\u81f3","\u5c0f\u6691","\u5927\u6691","\u7acb\u79cb","\u5904\u6691","\u767d\u9732","\u79cb\u5206","\u5bd2\u9732","\u971c\u964d","\u7acb\u51ac","\u5c0f\u96ea","\u5927\u96ea","\u51ac\u81f3"];

  /// 1900-2100各年的24节气日期速查表
  /// @Array Of Property
  /// @return 0x string For splice
  static List<String> sTermInfo = ['9778397bd097c36b0b6fc9274c91aa','97b6b97bd19801ec9210c965cc920e','97bcf97c3598082c95f8c965cc920f',
  '97bd0b06bdb0722c965ce1cfcc920f','b027097bd097c36b0b6fc9274c91aa','97b6b97bd19801ec9210c965cc920e',
  '97bcf97c359801ec95f8c965cc920f','97bd0b06bdb0722c965ce1cfcc920f','b027097bd097c36b0b6fc9274c91aa',
  '97b6b97bd19801ec9210c965cc920e','97bcf97c359801ec95f8c965cc920f','97bd0b06bdb0722c965ce1cfcc920f',
  'b027097bd097c36b0b6fc9274c91aa','9778397bd19801ec9210c965cc920e','97b6b97bd19801ec95f8c965cc920f',
  '97bd09801d98082c95f8e1cfcc920f','97bd097bd097c36b0b6fc9210c8dc2','9778397bd197c36c9210c9274c91aa',
  '97b6b97bd19801ec95f8c965cc920e','97bd09801d98082c95f8e1cfcc920f','97bd097bd097c36b0b6fc9210c8dc2',
  '9778397bd097c36c9210c9274c91aa','97b6b97bd19801ec95f8c965cc920e','97bcf97c3598082c95f8e1cfcc920f',
  '97bd097bd097c36b0b6fc9210c8dc2','9778397bd097c36c9210c9274c91aa','97b6b97bd19801ec9210c965cc920e',
  '97bcf97c3598082c95f8c965cc920f','97bd097bd097c35b0b6fc920fb0722','9778397bd097c36b0b6fc9274c91aa',
  '97b6b97bd19801ec9210c965cc920e','97bcf97c3598082c95f8c965cc920f','97bd097bd097c35b0b6fc920fb0722',
  '9778397bd097c36b0b6fc9274c91aa','97b6b97bd19801ec9210c965cc920e','97bcf97c359801ec95f8c965cc920f',
  '97bd097bd097c35b0b6fc920fb0722','9778397bd097c36b0b6fc9274c91aa','97b6b97bd19801ec9210c965cc920e',
  '97bcf97c359801ec95f8c965cc920f','97bd097bd097c35b0b6fc920fb0722','9778397bd097c36b0b6fc9274c91aa',
  '97b6b97bd19801ec9210c965cc920e','97bcf97c359801ec95f8c965cc920f','97bd097bd07f595b0b6fc920fb0722',
  '9778397bd097c36b0b6fc9210c8dc2','9778397bd19801ec9210c9274c920e','97b6b97bd19801ec95f8c965cc920f',
  '97bd07f5307f595b0b0bc920fb0722','7f0e397bd097c36b0b6fc9210c8dc2','9778397bd097c36c9210c9274c920e',
  '97b6b97bd19801ec95f8c965cc920f','97bd07f5307f595b0b0bc920fb0722','7f0e397bd097c36b0b6fc9210c8dc2',
  '9778397bd097c36c9210c9274c91aa','97b6b97bd19801ec9210c965cc920e','97bd07f1487f595b0b0bc920fb0722',
  '7f0e397bd097c36b0b6fc9210c8dc2','9778397bd097c36b0b6fc9274c91aa','97b6b97bd19801ec9210c965cc920e',
  '97bcf7f1487f595b0b0bb0b6fb0722','7f0e397bd097c35b0b6fc920fb0722','9778397bd097c36b0b6fc9274c91aa',
  '97b6b97bd19801ec9210c965cc920e','97bcf7f1487f595b0b0bb0b6fb0722','7f0e397bd097c35b0b6fc920fb0722',
  '9778397bd097c36b0b6fc9274c91aa','97b6b97bd19801ec9210c965cc920e','97bcf7f1487f531b0b0bb0b6fb0722',
  '7f0e397bd097c35b0b6fc920fb0722','9778397bd097c36b0b6fc9274c91aa','97b6b97bd19801ec9210c965cc920e',
  '97bcf7f1487f531b0b0bb0b6fb0722','7f0e397bd07f595b0b6fc920fb0722','9778397bd097c36b0b6fc9274c91aa',
  '97b6b97bd19801ec9210c9274c920e','97bcf7f0e47f531b0b0bb0b6fb0722','7f0e397bd07f595b0b0bc920fb0722',
  '9778397bd097c36b0b6fc9210c91aa','97b6b97bd197c36c9210c9274c920e','97bcf7f0e47f531b0b0bb0b6fb0722',
  '7f0e397bd07f595b0b0bc920fb0722','9778397bd097c36b0b6fc9210c8dc2','9778397bd097c36c9210c9274c920e',
  '97b6b7f0e47f531b0723b0b6fb0722','7f0e37f5307f595b0b0bc920fb0722','7f0e397bd097c36b0b6fc9210c8dc2',
  '9778397bd097c36b0b70c9274c91aa','97b6b7f0e47f531b0723b0b6fb0721','7f0e37f1487f595b0b0bb0b6fb0722',
  '7f0e397bd097c35b0b6fc9210c8dc2','9778397bd097c36b0b6fc9274c91aa','97b6b7f0e47f531b0723b0b6fb0721',
  '7f0e27f1487f595b0b0bb0b6fb0722','7f0e397bd097c35b0b6fc920fb0722','9778397bd097c36b0b6fc9274c91aa',
  '97b6b7f0e47f531b0723b0b6fb0721','7f0e27f1487f531b0b0bb0b6fb0722','7f0e397bd097c35b0b6fc920fb0722',
  '9778397bd097c36b0b6fc9274c91aa','97b6b7f0e47f531b0723b0b6fb0721','7f0e27f1487f531b0b0bb0b6fb0722',
  '7f0e397bd097c35b0b6fc920fb0722','9778397bd097c36b0b6fc9274c91aa','97b6b7f0e47f531b0723b0b6fb0721',
  '7f0e27f1487f531b0b0bb0b6fb0722','7f0e397bd07f595b0b0bc920fb0722','9778397bd097c36b0b6fc9274c91aa',
  '97b6b7f0e47f531b0723b0787b0721','7f0e27f0e47f531b0b0bb0b6fb0722','7f0e397bd07f595b0b0bc920fb0722',
  '9778397bd097c36b0b6fc9210c91aa','97b6b7f0e47f149b0723b0787b0721','7f0e27f0e47f531b0723b0b6fb0722',
  '7f0e397bd07f595b0b0bc920fb0722','9778397bd097c36b0b6fc9210c8dc2','977837f0e37f149b0723b0787b0721',
  '7f07e7f0e47f531b0723b0b6fb0722','7f0e37f5307f595b0b0bc920fb0722','7f0e397bd097c35b0b6fc9210c8dc2',
  '977837f0e37f14998082b0787b0721','7f07e7f0e47f531b0723b0b6fb0721','7f0e37f1487f595b0b0bb0b6fb0722',
  '7f0e397bd097c35b0b6fc9210c8dc2','977837f0e37f14998082b0787b06bd','7f07e7f0e47f531b0723b0b6fb0721',
  '7f0e27f1487f531b0b0bb0b6fb0722','7f0e397bd097c35b0b6fc920fb0722','977837f0e37f14998082b0787b06bd',
  '7f07e7f0e47f531b0723b0b6fb0721','7f0e27f1487f531b0b0bb0b6fb0722','7f0e397bd097c35b0b6fc920fb0722',
  '977837f0e37f14998082b0787b06bd','7f07e7f0e47f531b0723b0b6fb0721','7f0e27f1487f531b0b0bb0b6fb0722',
  '7f0e397bd07f595b0b0bc920fb0722','977837f0e37f14998082b0787b06bd','7f07e7f0e47f531b0723b0b6fb0721',
  '7f0e27f1487f531b0b0bb0b6fb0722','7f0e397bd07f595b0b0bc920fb0722','977837f0e37f14998082b0787b06bd',
  '7f07e7f0e47f149b0723b0787b0721','7f0e27f0e47f531b0b0bb0b6fb0722','7f0e397bd07f595b0b0bc920fb0722',
  '977837f0e37f14998082b0723b06bd','7f07e7f0e37f149b0723b0787b0721','7f0e27f0e47f531b0723b0b6fb0722',
  '7f0e397bd07f595b0b0bc920fb0722','977837f0e37f14898082b0723b02d5','7ec967f0e37f14998082b0787b0721',
  '7f07e7f0e47f531b0723b0b6fb0722','7f0e37f1487f595b0b0bb0b6fb0722','7f0e37f0e37f14898082b0723b02d5',
  '7ec967f0e37f14998082b0787b0721','7f07e7f0e47f531b0723b0b6fb0722','7f0e37f1487f531b0b0bb0b6fb0722',
  '7f0e37f0e37f14898082b0723b02d5','7ec967f0e37f14998082b0787b06bd','7f07e7f0e47f531b0723b0b6fb0721',
  '7f0e37f1487f531b0b0bb0b6fb0722','7f0e37f0e37f14898082b072297c35','7ec967f0e37f14998082b0787b06bd',
  '7f07e7f0e47f531b0723b0b6fb0721','7f0e27f1487f531b0b0bb0b6fb0722','7f0e37f0e37f14898082b072297c35',
  '7ec967f0e37f14998082b0787b06bd','7f07e7f0e47f531b0723b0b6fb0721','7f0e27f1487f531b0b0bb0b6fb0722',
  '7f0e37f0e366aa89801eb072297c35','7ec967f0e37f14998082b0787b06bd','7f07e7f0e47f149b0723b0787b0721',
  '7f0e27f1487f531b0b0bb0b6fb0722','7f0e37f0e366aa89801eb072297c35','7ec967f0e37f14998082b0723b06bd',
  '7f07e7f0e47f149b0723b0787b0721','7f0e27f0e47f531b0723b0b6fb0722','7f0e37f0e366aa89801eb072297c35',
  '7ec967f0e37f14998082b0723b06bd','7f07e7f0e37f14998083b0787b0721','7f0e27f0e47f531b0723b0b6fb0722',
  '7f0e37f0e366aa89801eb072297c35','7ec967f0e37f14898082b0723b02d5','7f07e7f0e37f14998082b0787b0721',
  '7f07e7f0e47f531b0723b0b6fb0722','7f0e36665b66aa89801e9808297c35','665f67f0e37f14898082b0723b02d5',
  '7ec967f0e37f14998082b0787b0721','7f07e7f0e47f531b0723b0b6fb0722','7f0e36665b66a449801e9808297c35',
  '665f67f0e37f14898082b0723b02d5','7ec967f0e37f14998082b0787b06bd','7f07e7f0e47f531b0723b0b6fb0721',
  '7f0e36665b66a449801e9808297c35','665f67f0e37f14898082b072297c35','7ec967f0e37f14998082b0787b06bd',
  '7f07e7f0e47f531b0723b0b6fb0721','7f0e26665b66a449801e9808297c35','665f67f0e37f1489801eb072297c35',
  '7ec967f0e37f14998082b0787b06bd','7f07e7f0e47f531b0723b0b6fb0721','7f0e27f1487f531b0b0bb0b6fb0722'];

  /// 数字转中文速查表
  /// @Array Of Property
  /// @trans ['日','一','二','三','四','五','六','七','八','九','十']
  /// @return Cn string
  static List<String> nStr1 = ["\u65e5","\u4e00","\u4e8c","\u4e09","\u56db","\u4e94","\u516d","\u4e03","\u516b","\u4e5d","\u5341"];

  /// 日期转农历称呼速查表
  /// @Array Of Property
  /// @trans ['初','十','廿','卅']
  /// @return Cn string
  static List<String> nStr2 = ["\u521d","\u5341","\u5eff","\u5345"];

  /// 月份转农历称呼速查表
  /// @Array Of Property
  /// @trans [正, 二, 三, 四, 五, 六, 七, 八, 九, 十, 冬, 腊]
  /// @return Cn string
  static List<String> nStr3 = ["\u6b63","\u4e8c","\u4e09","\u56db","\u4e94","\u516d","\u4e03","\u516b","\u4e5d","\u5341","\u51ac","\u814a"];

  /// 返回农历y年一整年的总天数
  /// @param lunar Year
  /// @return Number
  /// @eg:var count = calendar.lYearDays(1987) ;//count=387
  static lYearDays(int y) {
    int i, sum = 348;
    for(i=0x8000; i>0x8; i>>=1) { sum += ((CalendarConverter.lunarInfo[y-1900] & i) != 0 ? 1: 0); }
    return(sum+CalendarConverter.leapDays(y));
  }

  /// 返回农历y年闰月是哪个月；若y年没有闰月 则返回0
  /// @param lunar Year
  /// @return Number (0-12)
  /// @eg:var leapMonth = calendar.leapMonth(1987) ;//leapMonth=6
  static leapMonth(int y) { //闰字编码 \u95f0
    return(CalendarConverter.lunarInfo[y-1900] & 0xf);
  }

  /// 返回农历y年闰月的天数 若该年没有闰月则返回0
  /// @param lunar Year
  /// @return Number (0、29、30)
  /// @eg:var leapMonthDay = calendar.leapDays(1987) ;//leapMonthDay=29
  static leapDays(int y) {
    if(CalendarConverter.leapMonth(y) != 0) {
      return((CalendarConverter.lunarInfo[y-1900] & 0x10000) != 0 ? 30: 29);
    }
    return(0);
  }

  /// 返回农历y年m月（非闰月）的总天数，计算m为闰月时的天数请使用leapDays方法
  /// @param lunar Year
  /// @return Number (-1、29、30)
  /// @eg:var MonthDay = calendar.monthDays(1987,9) ;//MonthDay=29
  static monthDays(int y, int m) {
    if(m>12 || m<1) {return -1;}//月份参数从1至12，参数错误返回-1
    return( (CalendarConverter.lunarInfo[y-1900] & (0x10000>>m)) != 0 ? 30: 29 );
  }

  /// 返回公历(!)y年m月的天数
  /// @param solar Year
  /// @return Number (-1、28、29、30、31)
  /// @eg:var solarMonthDay = calendar.leapDays(1987) ;//solarMonthDay=30
  static solarDays(int y, int m) {
    if(m>12 || m<1) {return -1;} //若参数错误 返回-1
    var ms = m-1;
    if(ms==1) { //2月份的闰平规律测算后确认返回28或29
      return(((y%4 == 0) && (y%100 != 0) || (y%400 == 0))? 29: 28);
    }else {
      return(CalendarConverter.solarMonth[ms]);
    }
  }

  /// 农历年份转换为干支纪年
  /// @param lYear 农历年的年份数
  /// @return Cn string
  static toGanZhiYear(int lYear) {
    var ganKey = (lYear - 3) % 10;
    var zhiKey = (lYear - 3) % 12;
    if(ganKey == 0) ganKey = 10;//如果余数为0则为最后一个天干
    if(zhiKey == 0) zhiKey = 12;//如果余数为0则为最后一个地支
    return CalendarConverter.Gan[ganKey-1] + CalendarConverter.Zhi[zhiKey-1];
  }

  /// 公历月、日判断所属星座
  /// @param cMonth [description]
  /// @param cDay [description]
  /// @return Cn string
  static toAstro(int cMonth, int cDay) {
    var s  = "\u9b54\u7faf\u6c34\u74f6\u53cc\u9c7c\u767d\u7f8a\u91d1\u725b\u53cc\u5b50\u5de8\u87f9\u72ee\u5b50\u5904\u5973\u5929\u79e4\u5929\u874e\u5c04\u624b\u9b54\u7faf";
    var arr = [20,19,21,21,21,22,23,23,23,23,22,22];
    var startI = cMonth*2 - (cDay < arr[cMonth-1] ? 2 : 0);
    return "${s.substring(startI,startI+2)}\u5ea7";//座
  }

  /// 传入offset偏移量返回干支
  /// @param offset 相对甲子的偏移量
  /// @return Cn string
  static toGanZhi(int offset) {
    return CalendarConverter.Gan[offset%10] + CalendarConverter.Zhi[offset%12];
  }

  /// 传入公历(!)y年获得该年第n个节气的公历日期
  /// @param y公历年(1900-2100)；n二十四节气中的第几个节气(1~24)；从n=1(小寒)算起
  /// @return day Number
  /// @eg:var _24 = calendar.getTerm(1987,3) ;//_24=4;意即1987年2月4日立春
  static getTerm(int y, int n) {
    if(y<1900 || y>2100) {return -1;}
    if(n<1 || n>24) {return -1;}
    var table = CalendarConverter.sTermInfo[y-1900];
    var info = [
      int.parse('0x${table.substring(0,5)}').toString() ,
      int.parse('0x${table.substring(5,10)}').toString(),
      int.parse('0x${table.substring(10,15)}').toString(),
      int.parse('0x${table.substring(15,20)}').toString(),
      int.parse('0x${table.substring(20,25)}').toString(),
      int.parse('0x${table.substring(25,30)}').toString()
    ];
    var calday = [
      info[0].substring(0,1),
      info[0].substring(1,3),
      info[0].substring(3,4),
      info[0].substring(4,6),
      info[1].substring(0,1),
      info[1].substring(1,3),
      info[1].substring(3,4),
      info[1].substring(4,6),
      info[2].substring(0,1),
      info[2].substring(1,3),
      info[2].substring(3,4),
      info[2].substring(4,6),
      info[3].substring(0,1),
      info[3].substring(1,3),
      info[3].substring(3,4),
      info[3].substring(4,6),
      info[4].substring(0,1),
      info[4].substring(1,3),
      info[4].substring(3,4),
      info[4].substring(4,6),
      info[5].substring(0,1),
      info[5].substring(1,3),
      info[5].substring(3,4),
      info[5].substring(4,6),
    ];
    return int.parse(calday[n-1]);
  }

  /// 传入农历数字月份返回汉语通俗表示法
  /// @param lunar month
  /// @return Cn string
  /// @eg:var cnMonth = calendar.toChinaMonth(12) ;//cnMonth='腊月'
  static toChinaMonth(int m) { // 月 => \u6708
    if(m>12 || m<1) {return -1;} //若参数错误 返回-1
    var s = CalendarConverter.nStr3[m-1];
    s+= "\u6708";//加上月字
    return s;
  }

  /// 传入农历日期数字返回汉字表示法
  /// @param lunar day
  /// @return Cn string
  /// @eg:var cnDay = calendar.toChinaDay(21) ;//cnMonth='廿一'
  static toChinaDay(int d){ //日 => \u65e5
    var s;
    switch (d) {
      case 10:
        s = '\u521d\u5341'; break;
      case 20:
        s = '\u4e8c\u5341'; break;
      case 30:
        s = '\u4e09\u5341'; break;
      default :
        s = CalendarConverter.nStr2[(d/10).floor()];
        s += CalendarConverter.nStr1[d%10];
    }
    return(s);
  }

  /// 年份转生肖[!仅能大致转换] => 精确划分生肖分界线是“立春”
  /// @param y year
  /// @return Cn string
  /// @eg:var animal = calendar.getAnimal(1987) ;//animal='兔'
  static getAnimal(int y) {
    return CalendarConverter.Animals[(y - 4) % 12];
  }

  /// 传入阳历年月日获得详细的公历、农历object信息 <=>JSON
  /// @param y solar year
  /// @param m solar month
  /// @param d solar day
  /// @return JSON object
  /// @eg:console.log(calendar.solar2lunar(1987,11,01));
  static Lunar? solar2lunar (int y, int m, int d) { //参数区间1900.1.31~2100.12.31
    if(y<1900 || y>2100) {return null ;}//年份限定、上限
    if(y==1900&&m==1&&d<31) {return null ;}//下限
    // 获得日期与1900,1,31的天数差异
    int offset = DateTime.utc(y,m,d).difference(DateTime.utc(1900,1,31)).inDays;
    int i, temp=0;
    for(i=1900; i<2101 && offset>0; i++) {
      temp=CalendarConverter.lYearDays(i);
      offset-=temp;
    }
    if(offset<0) { offset+=temp; i--; }
    //是否今天
    var isTodayObj = DateTime.now(),isToday=false;
    if(isTodayObj.year==y && isTodayObj.month==m && isTodayObj.day==d) {
      isToday = true;
    }
    //星期几
    var nWeek = DateTime(y,m,d).weekday,cWeek = CalendarConverter.nStr1[nWeek == 7 ? 0 : nWeek];
    //农历年
    var year = i;
    var leap = CalendarConverter.leapMonth(i); //闰哪个月
    var isLeap = false;
    //效验闰月
    for(i=1; i<13 && offset>0; i++) {
      //闰月
      if(leap>0 && i==(leap+1) && isLeap==false){
        --i;
        isLeap = true; temp = CalendarConverter.leapDays(year); //计算农历闰月天数
      }
      else{
        temp = CalendarConverter.monthDays(year, i);//计算农历普通月天数
      }
      //解除闰月
      if(isLeap==true && i==(leap+1)) { isLeap = false; }
      offset -= temp;
    }
    if(offset==0 && leap>0 && i==leap+1)
      {
        if(isLeap){
          isLeap = false;
        }else{
          isLeap = true; --i;
        }
      }
    if(offset<0){ offset += temp; --i; }
    //农历月
    var month  = i;
    //农历日
    var day   = offset + 1;
    //天干地支处理
    var gzY   =  CalendarConverter.toGanZhiYear(year);
    //月柱 1900年1月小寒以前为 丙子月(60进制12)
    var firstNode  = CalendarConverter.getTerm(year,(m*2-1));//返回当月「节」为几日开始
    var secondNode = CalendarConverter.getTerm(year,(m*2));//返回当月「节」为几日开始

    //依据12节气修正干支月
    var gzM   =  CalendarConverter.toGanZhi((y-1900)*12+m+11);
    if(d>=firstNode) {
      gzM   =  CalendarConverter.toGanZhi((y-1900)*12+m+12);
    }
    //传入的日期的节气与否
    var isTerm = false;
    String? term;
    if(firstNode==d) {
      isTerm = true;
      term  = CalendarConverter.solarTerm[m*2-2];
    }
    if(secondNode==d) {
      isTerm = true;
      term  = CalendarConverter.solarTerm[m*2-1];
    }
    //日柱 当月一日与 1900/1/1 相差天数
    int dayCyclical = DateTime.utc(y,m,1).difference(DateTime.utc(1900,1,1)).inDays + 10;
    var gzD = CalendarConverter.toGanZhi(dayCyclical+d-1);
    //该日期所属的星座
    var astro = CalendarConverter.toAstro(m,d);
    return Lunar(
        lYear: year,
        lMonth: month,
        lDay: day,
        Animal: CalendarConverter.getAnimal(year),
        IMonthCn: (isLeap?"\u95f0":'')+CalendarConverter.toChinaMonth(month),
        IDayCn: CalendarConverter.toChinaDay(day),
        cYear: y,
        cMonth: m,
        cDay: d,
        gzYear: gzY,
        gzMonth: gzM,
        gzDay: gzD,
        isToday: isToday,
        isLeap: isLeap,
        nWeek: nWeek,
        ncWeek: "\u661f\u671f"+cWeek,
        isTerm: isTerm,
        term: term,
        astro: astro
    );
  }
}