import 'package:flutter/material.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';

import '../utils/generate_calendar.dart';
import '../widgets/month.dart';
import '../enums/select_type.dart';
import '../model/month.dart';
import '../types/index.dart';

/// 日历主体组件

class Body extends StatefulWidget {

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

  Body({
    Key? key,
    required this.type,
    required this.firstDate,
    required this.lastDate,
    required this.selectedDate,
    required this.maxRange,
    required this.onSelect,
    this.bottomFormatter,
  }) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {

  /// 日历数据
  late final List<Month> _calendarData;

  /// 滚动控制器，控制内容初始位置
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    _calendarData = GenerateCalendar.getCalendarData(widget.firstDate, widget.lastDate);

    _setInitialPosition();
  }

  /// 设置滚动的初始位置
  _setInitialPosition() {
    /// 未选中内容直接返回
    if(widget.selectedDate.isEmpty)return;

    /// 获得最小日期，多选的时候需要排序一下获取
    DateTime minDate = widget.selectedDate.length > 1 && widget.type == SelectType.multiple ? _getMinDateTime(widget.selectedDate) : widget.selectedDate[0];

    /// 选中的起始索引
    int startIndex = _calendarData.indexWhere((e) => (e.year == minDate.year && e.month == minDate.month));

    /// 算出选中的初始位置
    double initialPosition = _getMonthY(startIndex);

    /// 组件渲染后开始跳转到指定位置
    WidgetsBinding.instance.addPostFrameCallback((callback){
      _controller.jumpTo(initialPosition);
    });
  }

  /// 获取每个月的位置
  double _getMonthY(int index) {
    return _calendarData.getRange(0, index).fold(0, (previousValue, element) {
      return previousValue + _getMonthHeight(element);
    });
  }

  /// 获取每个月的高度
  double _getMonthHeight(Month month) {
    int firstDayIndex = DateTime(month.year, month.month, 1).weekday;
    firstDayIndex = firstDayIndex == DateTime.sunday ? 0 : firstDayIndex;
    int rows = ((month.days + firstDayIndex) / DateTime.daysPerWeek).ceil();
    return  (50 + 64 * rows).toDouble();
  }

  /// 获取最小日期
  DateTime _getMinDateTime(List<DateTime> selectedDate) {
    var tempList = selectedDate.getRange(0, selectedDate.length).toList();
    tempList.sort((a, b) => a.millisecondsSinceEpoch - b.millisecondsSinceEpoch);
    return tempList[0];
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: SafeArea(
          top: false,
          bottom: false,
          child: MediaQuery.removePadding(
            context: context,
            removeTop: true,
            removeBottom: true,
            child: ListView.builder(
              controller: _controller,
              itemBuilder: (BuildContext context, int index){
                Month item = _calendarData[index];
                return StickyHeader(
                  header: Container(
                    height: 50,
                    color: Colors.white,
                    alignment: Alignment.center,
                    child: Text("${item.year}年${item.month}月", style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Color(0xff0c0c0c),
                      fontSize: 16,
                    ),),
                  ),
                  content: MonthView(
                    type: widget.type,
                    firstDate: widget.firstDate,
                    lastDate: widget.lastDate,
                    selectedDate: widget.selectedDate,
                    maxRange: widget.maxRange,
                    onSelect: widget.onSelect,
                    bottomFormatter: widget.bottomFormatter,
                    monthData: item,
                  ),
                );

              },
              itemCount: _calendarData.length,
            ),
          ),
        ),
    );
  }
}
