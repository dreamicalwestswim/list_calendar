import 'package:flutter/material.dart';

import '../enums/day_type.dart';
import '../enums/select_type.dart';
import '../model/day_color.dart';
import '../model/lunar.dart';
import '../model/month.dart';
import '../types/index.dart';
import '../utils/assets_cache.dart';
import '../utils/calendar_converter.dart';
import '../utils/generate_calendar.dart';
import 'list_calendar_theme.dart';

/// 日历月组件
class MonthView extends StatefulWidget {
  /// 选择类型
  SelectType type;

  /// 可选择的最小日期(今天)
  DateTime firstDate;

  /// 可选择的最大日期(今天往后延6个月)
  DateTime lastDate;

  /// 当前选中的日期
  List<DateTime> selectedDate;

  /// 日期区间最多可选天数
  int maxRange;

  /// 选择回调
  ValueChanged<DateTime> onSelect;

  /// 底部文字配置
  BottomFormatter bottomFormatter;

  /// 月数据
  Month monthData;

  MonthView({
    Key? key,
    required this.type,
    required this.firstDate,
    required this.lastDate,
    required this.selectedDate,
    required this.maxRange,
    required this.onSelect,
    this.bottomFormatter,
    required this.monthData,
  }) : super(key: key);

  @override
  State<MonthView> createState() => _MonthViewState();
}

class _MonthViewState extends State<MonthView> {

  /// 获取每一天的类型
  DayType? _getDayType(DateTime dateTime) {
    // 超过可选日期范围禁用
    if(dateTime.isBefore(widget.firstDate) || dateTime.isAfter(widget.lastDate)) {
      return DayType.disabled;
    }

    // 选择数据时的类型
    if(widget.selectedDate.isNotEmpty){
      if(widget.type == SelectType.single){
        if(dateTime.isAtSameMomentAs(widget.selectedDate[0]))return DayType.selected;
      } else if(widget.type == SelectType.multiple){
        for(int i = 0;i<widget.selectedDate.length;i++){
          if(dateTime.isAtSameMomentAs(widget.selectedDate[i]))return DayType.selected;
        }
        // 选中数量达到最大数其他的都禁用
        if(widget.selectedDate.length >= widget.maxRange)return DayType.disabled;
      } else if(widget.type == SelectType.range){
        DayType? res;
        for(int i = 0;i<widget.selectedDate.length;i++){
          if(dateTime.isAtSameMomentAs(widget.selectedDate[i])){
            res = i == 0 ? DayType.start : DayType.end;
          }
        }
        if(widget.selectedDate.length == 2){
          if(dateTime.isAfter(widget.selectedDate[0]) && dateTime.isBefore(widget.selectedDate[1]) ){
            return DayType.middle;
          }
        }
        if(res != null)return res;
      }
    }

    // 周末
    if(dateTime.weekday == DateTime.saturday || dateTime.weekday == DateTime.sunday){
      return DayType.weekend;
    }
  }

  /// 获取每一天的颜色
  DayColor? _getDayColor(DayType? dayType) {
    ListCalendarTheme? theme = ListCalendarTheme.of(context);
    if(dayType == DayType.disabled) {
      return DayColor(foregroundColor: const Color(0xffc8c9cc));
    }

    if(dayType == DayType.selected || dayType == DayType.start || dayType == DayType.end) {
      return DayColor(foregroundColor: theme?.selectedForegroundColor ?? Colors.white, backgroundColor: theme?.selectedBackgroundColor ?? const Color(0xffee0a24));
    }

    if(dayType == DayType.middle) {
      return DayColor(foregroundColor: theme?.middleForegroundColor ?? const Color(0xffee0a24), backgroundColor: theme?.middleBackgroundColor ?? const Color(0xfffde7ea));
    }

    if(dayType == DayType.weekend) {
      return DayColor(foregroundColor: theme?.weekendColor ?? const Color.fromRGBO(255,10,37,.82));
    }
  }

  /// 获取边框半径
  BorderRadius _getBorderRadius(DayType? dayType) {
    if(dayType == DayType.start) {
      return const BorderRadius.only(topLeft: Radius.circular(5), bottomLeft: Radius.circular(5));
    }
    if(dayType == DayType.middle) {
      return BorderRadius.circular(0);
    }
    if(dayType == DayType.end) {
      return const BorderRadius.only(topRight: Radius.circular(5), bottomRight: Radius.circular(5));
    }
    return BorderRadius.circular(5);
  }

  /// 底部默认提示文字
  String _getBottomText(DayType? dayType, DateTime date) {
    String res = '';
    switch(dayType){
      case DayType.start:
        res = '开始';
        break;
      case DayType.end:
        res = '结束';
        break;
      case DayType.middle:
      case DayType.selected:
        res = '✓';
        break;
      case DayType.disabled:
        res = '-';
        break;
    }

    // 外部配置了就用外部文字
    String? newText;
    if(widget.bottomFormatter != null) {
      newText = widget.bottomFormatter!(dayType, date);
    }
    return newText ?? res;
  }


  /// 获取农历和节日
  String _getLunarFestival(DateTime date) {
    /// 转换成农历日期
    Lunar lunar;
    try {
      /// 农历数据并不能通过一个阳历日期就推演出来，需要一个起始时间和未来的时间，再根据差异进行推演，过程比较复杂，相对耗时！
      /// 此处内容属于动态构建的，但是农历数据是死的，所有放到缓存里面，防止重复推演农历数据，产生无用的性能开销。
      String key = "${date.year}-${date.month}-${date.day}";
      lunar = AssetsCache.getItem<Lunar>(key) ?? AssetsCache.setItem<Lunar>(key, CalendarConverter.solar2lunar(date.year, date.month, date.day))!;
    } catch (e) {
      return "";
    }


    if(lunar.isToday)return "今天";


    /// 默认显示农历天，1号显示月
    String res = lunar.lDay == 1 ? lunar.IMonthCn : lunar.IDayCn;

    /// 节气
    if(lunar.isTerm){
      res = lunar.term!;
    }

    /// 阳历节日
    var sFestival = GenerateCalendar.FESTIVALS.solar[date.month]![date.day];
    if(sFestival != null){
      res = sFestival;
    }

    /// 农历节日
    var lFestival = GenerateCalendar.FESTIVALS.lunar[lunar.lMonth]![lunar.lDay];
    if(lFestival != null){
      res = lFestival;
    }
    return res;
  }


  /// 构建每月日期
  Widget _buildMonth() {
    int year = widget.monthData.year, month = widget.monthData.month, days = widget.monthData.days;
    // 每月1号是周几(通过这个索引与周几对齐)
    int firstDayIndex = DateTime(year, month, 1).weekday;
    firstDayIndex = firstDayIndex == DateTime.sunday ? 0 : firstDayIndex;
    return Stack(
      children: [
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          top: 0,
          child: Center(
            child: Text("$month", style: const TextStyle(
              fontSize: 160,
              color: Color.fromRGBO(242, 243, 245, 0.6),
            ),),
          ),
        ),
        LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints){
          // double screenWidth = MediaQuery.of(context).size.width;
          double maxWidth = constraints.maxWidth;
          double boxW = maxWidth / 100 * 14.285;
          return Wrap(
            children: List.generate(days, (int index) => index + 1).map((day) {
              final dateTime = DateTime(year, month, day);
              final dayType = _getDayType(dateTime);
              final dayColor = _getDayColor(dayType);
              return Container(
                width: boxW,
                height: 64,
                margin: EdgeInsets.only(left: day == 1 ? boxW * firstDayIndex : 0),
                child: UnconstrainedBox(
                  child: GestureDetector(
                    onTap: (){
                      if(dayType != DayType.disabled)widget.onSelect(dateTime);
                    },
                    child: Container(
                      width: boxW,
                      height: 54,
                      padding: const EdgeInsets.only(top: 2),
                      constraints: BoxConstraints(maxWidth: widget.type != SelectType.range ? 54 : double.infinity),
                      decoration: BoxDecoration(
                        color: dayColor?.backgroundColor ?? const Color.fromRGBO(200, 200, 200, 0),
                        borderRadius: _getBorderRadius(dayType),
                      ),
                      child: Column(
                        children: [
                          Text("$day", style: TextStyle(fontSize: 16, color: dayColor?.foregroundColor ?? const Color(0xff0c0c0c)),),
                          Text(
                            _getLunarFestival(dateTime),
                            style: TextStyle(fontSize: 11, color: dayColor?.foregroundColor ?? const Color(0xff8d8d8d), overflow: TextOverflow.ellipsis),
                          ),
                          Text(
                            _getBottomText(dayType, dateTime),
                            style: TextStyle(fontSize: 11, color: dayColor?.foregroundColor ?? const Color(0xff8d8d8d), overflow: TextOverflow.ellipsis),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        }),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildMonth();
  }
}
