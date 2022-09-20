import 'package:flutter/material.dart';

import './body.dart';
import './footer.dart';
import './header.dart';
import '../enums/select_type.dart';
import '../types/index.dart';



/// 日历选择器组件
class ListCalendar extends StatefulWidget {
  /// 选择类型
  SelectType? type;

  /// 可选择的最小日期(今天)
  DateTime? firstDate;

  /// 可选择的最大日期(今天往后延6个月)
  DateTime? lastDate;

  /// 日历默认选中的日期(不需要传时间，内部用毫秒对比，每天的0时0分0秒0毫秒开始)
  List<DateTime>? initialDate;

  /// 底部文字配置
  BottomFormatter bottomFormatter;

  /// 是否允许日期范围的起止时间为同一天
  bool? allowSameDay;

  /// 日期区间或多选最多可选天数
  int? maxRange;

  /// 区间选中超过最大值触发
  RangePrompt rangePrompt;

  /// 底部按钮文字
  String? confirmText;

  /// 底部按钮禁用文字
  String? confirmDisabledText;

  /// 确定回调
  ConfirmCallback onConfirm;

  ListCalendar({
    Key? key,
    this.type = SelectType.single,
    DateTime? firstDate,
    DateTime? lastDate,
    List<DateTime>? initialDate,
    this.bottomFormatter,
    this.allowSameDay = false,
    this.maxRange = 30,
    this.rangePrompt,
    this.confirmText = '确定',
    this.confirmDisabledText = '确定',
    this.onConfirm,
  }) : super(key: key) {

    DateTime dateTime = DateTime.now();
    this.firstDate = firstDate ?? DateTime(dateTime.year, dateTime.month, dateTime.day);
    this.lastDate = lastDate ?? DateTime(dateTime.year, dateTime.month + 6, dateTime.day);
    this.initialDate = initialDate ?? [DateTime(dateTime.year, dateTime.month, dateTime.day)];

  }

  @override
  State<ListCalendar> createState() => _ListCalendarState();
}

class _ListCalendarState extends State<ListCalendar> {

  /// 选中的日期
  late List<DateTime> _selectedDate;

  @override
  void initState() {
    _selectedDate = widget.initialDate!;
  }

  /// 处理日期选择
  void _handlerSelect(DateTime dateTime) {

    setState((){
      // 单选
      if(widget.type == SelectType.single){
        _selectedDate = [dateTime];
      } else if(widget.type == SelectType.multiple){
        // 多选
        if(_selectedDate.any((item) => item.isAtSameMomentAs(dateTime))) {
          // 存在就删除掉
          _selectedDate.removeWhere((item) => item.isAtSameMomentAs(dateTime));
        } else {
          // 不存在就加入进去
          _selectedDate.add(dateTime);
        }
      } else if(widget.type == SelectType.range){
        // 区间选择
        DateTime date = dateTime;
        if(_selectedDate.length == 1){
          DateTime startDate = _selectedDate[0];
          // 第二个小于第一个直接删掉第一个, 不允许同一天也会删除第一个
          if(dateTime.isBefore(startDate) || (!widget.allowSameDay! && dateTime.isAtSameMomentAs(startDate))){
            _selectedDate.removeAt(0);
          } else {
            Duration difference = dateTime.difference(startDate);
            if(difference.inDays > widget.maxRange!){
              // 由外部去提示自由度会高很多
              if(widget.rangePrompt != null)widget.rangePrompt!(widget.maxRange!);
              // 结束日期设置成最大允许日期
              date = DateTime(startDate.year, startDate.month, startDate.day + widget.maxRange!);
            }
          }
        } else if(_selectedDate.length > 1){
          // 已经有两个值直接清空数组
          _selectedDate.clear();
        }
        _selectedDate.add(date);
      }
    });

  }

  /// 确认
  void _handlerConfirm() {
    /// 拷贝一份，防止日历被缓存的情况下，外部对选择日期进行了修改造成影响。
    List<DateTime> selectedDate = _selectedDate.map((e) => DateTime.fromMicrosecondsSinceEpoch(e.microsecondsSinceEpoch)).toList();
    /// 传入确认回调
    if(widget.onConfirm != null)widget.onConfirm!(selectedDate);
    /// 传入弹窗返回值
    Navigator.pop(context, selectedDate);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Header(),
          Body(
            type: widget.type!,
            firstDate: widget.firstDate!,
            lastDate: widget.lastDate!,
            selectedDate: _selectedDate,
            maxRange: widget.maxRange!,
            bottomFormatter: widget.bottomFormatter,
            onSelect: _handlerSelect,
          ),
          Footer(
            confirmDisabledText: widget.confirmDisabledText!,
            selectedDate: _selectedDate,
            type: widget.type!,
            confirmText: widget.confirmText!,
            onPressed: _handlerConfirm,
          ),
        ],
      ),
    );
  }
}
