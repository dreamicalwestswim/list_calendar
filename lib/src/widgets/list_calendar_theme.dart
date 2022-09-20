import 'package:flutter/material.dart';

/// 日历主题(彩色部分可修改，使其更贴近您的app主题)

class ListCalendarTheme extends InheritedWidget {
  /// 头部背景颜色
  Color? headBackgroundColor;

  /// 头部前景颜色
  Color? headForegroundColor;

  /// 按钮背景颜色
  Color? confirmBackgroundColor;

  /// 按钮前景颜色
  Color? confirmForegroundColor;

  /// 选中背景颜色
  Color? selectedBackgroundColor;

  /// 选中前景颜色
  Color? selectedForegroundColor;

  /// 中间背景颜色
  Color? middleBackgroundColor;

  /// 中间前景颜色
  Color? middleForegroundColor;

  /// 周末颜色
  Color? weekendColor;

  ListCalendarTheme({
    Key? key,
    required Widget child,
    this.headBackgroundColor = Colors.blue,
    this.headForegroundColor = Colors.white,
    this.confirmBackgroundColor = Colors.blue,
    this.confirmForegroundColor = Colors.white,
    this.selectedBackgroundColor = Colors.blue,
    this.selectedForegroundColor = Colors.white,
    this.middleBackgroundColor,
    this.middleForegroundColor = Colors.blue,
    this.weekendColor = Colors.blue,
  }) : super(key: key, child: child){
    middleBackgroundColor ?? (middleBackgroundColor = Colors.blue[100]);
  }

  /// 定义一个便捷方法，方便子树中的widget获取共享数据
  static ListCalendarTheme? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ListCalendarTheme>();
  }

  /// 该回调决定当data发生变化时，是否通知子树中依赖data的Widget重新build
  @override
  bool updateShouldNotify(ListCalendarTheme old) {
    return true;
  }
}