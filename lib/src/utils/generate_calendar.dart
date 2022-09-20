import '../model/month.dart';
import '../model/festivals.dart';

/// 生成日历所需各种数据工具类

abstract class GenerateCalendar {
  /// 获取每月天数(移动端只需要处理一下闰年就行，不需要像pc那样每月前后补足42个数据)
  static List<int> getDaysPerMonths(year) {
    // 定义每个月的天数，如果是闰年第二月改为29天
    List<int> daysInMonth = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
    // 4年一闰，100年不闰，400年一闰。
    if ((year % 4 == 0 && year % 100 != 0) || year % 400 == 0) {
      daysInMonth[1] = 29;
    }
    return daysInMonth;
  }

  /// 获取最小到最大之间的日期数据(dart月份是从1开始的和js从0开始不一样)
  static List<Month> getCalendarData(
      DateTime minDate, DateTime maxDate) {
    // 先获取年间隔
    int len = maxDate.year - minDate.year;
    List<Month> res = [];
    // 根据年间隔决定创建几年数据，没有间隔也需要创建当年的数据
    for (int i = 0; i <= len; i++) {
      // 获取每一年的数据
      int year = i + minDate.year;
      List<int> daysPerMonths = getDaysPerMonths(year);
      // 截掉最后一年后面多余的数据(如果是同一年先截掉后面的数据，保证前面索引不发生变化)
      if (i == len) {
        daysPerMonths.removeRange(maxDate.month, daysPerMonths.length);
      }
      // 删掉第一年前面的多余数据
      if (i == 0) {
        daysPerMonths.removeRange(0, minDate.month - 1);
      }
      // 为每一个数据标记年月天数，方便外部使用
      List<Month> tempList = [];
      for (int j = 0; j < daysPerMonths.length; j++) {
        tempList.add(Month(
            year: year,
            // 因为前面的多余数据被截掉了，所以起使月需要加上最小日期月数来计算，后面的就可以直接用j+1当月索引
            month: i == 0 ? j + minDate.month : j + 1,
            days: daysPerMonths[j]));
      }
      res.addAll(tempList);
    }
    return res;
  }

  /// 节日数据
  static Festivals FESTIVALS = Festivals(
      solar: {
        1: {1: '元旦节'},
        2: {14: '情人节'},
        3: {
          8: '妇女节',
          12: '植树节',
          14: '白色情人节',
        },
        4: {1: '愚人节', 5: '清明节'},
        5: {1: '劳动节'},
        6: {1: '儿童节'},
        7: {1: '建党节'},
        8: {1: '建军节'},
        9: {10: '教师节'},
        10: {1: '国庆节'},
        11: {},
        12: {1: '爱滋病日', 25: '圣诞节'}
      },
      lunar: {
        1: {1: '春节', 15: '元宵节'},
        2: {2: '龙抬头'},
        3: {},
        4: {},
        5: {5: '端午节'},
        6: {},
        7: {7: '七夕', 15: '中元节'},
        8: {15: '中秋节'},
        9: {9: '重阳节'},
        10: {},
        11: {},
        12: {8: '腊八节', 23: '小年', 30: '除夕'}
      }
  );
}

