import 'package:flutter/material.dart';

import '../enums/select_type.dart';
import 'list_calendar_theme.dart';
/// 日历尾部组件

class Footer extends StatelessWidget {

  /// 按钮禁用后文字
  String confirmDisabledText;

  /// 按钮文字
  String confirmText;

  /// 选中日期
  List<DateTime> selectedDate;

  /// 选择类型
  SelectType type;

  /// 点击按钮事件回调
  VoidCallback onPressed;

  /// 按钮背景颜色
  Color? confirmBackgroundColor;

  /// 按钮前景颜色
  Color? confirmForegroundColor;

  Footer({
    Key? key,
    required this.confirmDisabledText,
    required this.selectedDate,
    required this.type,
    required this.confirmText,
    required this.onPressed,
    this.confirmBackgroundColor,
    this.confirmForegroundColor,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    ListCalendarTheme? theme = ListCalendarTheme.of(context);

    /// 根据选择类型与选中日期判断禁用
    bool disable = selectedDate.isEmpty || (type == SelectType.range && selectedDate.length < 2);
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
        decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
              )
            ]
        ),
        child: SafeArea(
          top: false,
          child: AnimatedOpacity(
            opacity: disable == true ? 0.5 : 1,
            duration: const Duration(milliseconds: 300),
            child: ElevatedButton(
              onPressed: disable == true ? null : onPressed,
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(theme?.confirmBackgroundColor ?? const Color(0xffee0a24)),
                overlayColor: MaterialStateProperty.all(theme?.confirmBackgroundColor ?? const Color(0xffee0a24)),
                foregroundColor: MaterialStateProperty.all(theme?.confirmForegroundColor ?? Colors.white),
                shape: MaterialStateProperty.all(const StadiumBorder()),
                fixedSize: MaterialStateProperty.all(const Size.fromWidth(double.maxFinite)),
              ),
              child: Text(disable == true ? confirmDisabledText : confirmText),
            ),
          ),
        )
    );
  }
}
