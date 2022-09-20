import 'package:flutter/material.dart';

import 'list_calendar_theme.dart';
/// 日历头部组件

class Header extends StatelessWidget {
  Header({Key? key}) : super(key: key);

  final List<String> weekdays = [
    '日',
    '一',
    '二',
    '三',
    '四',
    '五',
    '六',
  ];

  @override
  Widget build(BuildContext context) {
    ListCalendarTheme? theme = ListCalendarTheme.of(context);

    return Container(
      padding: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: theme?.headBackgroundColor ?? Colors.white,
          border: const Border(bottom: BorderSide(width: 0.5, color: Color(0xffececec))),
      ),
      child: SafeArea(
          bottom: false,
          child:Column(
            children: <Widget>[
              Container(
                width: double.maxFinite,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                margin: const EdgeInsets.symmetric(vertical: 15),
                child: Stack(
                  alignment: AlignmentDirectional.center,
                  children: [
                    Positioned(
                      left: 0,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.arrow_back_ios,
                          size: 20,
                          color: theme?.headForegroundColor ?? Colors.black,
                        ),
                      ),
                    ),
                    Text(
                      "日期选择",
                      style: TextStyle(fontSize: 18, color: theme?.headForegroundColor ?? Colors.black),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: weekdays.map((item) {
                  return Text(
                    item,
                    style: TextStyle(fontSize: 14, color: theme?.headForegroundColor ?? Colors.black),
                  );
                }).toList(),
              )
            ],
          )
      ),
    );
  }
}
