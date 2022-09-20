import '../enums/day_type.dart';

/// 类型别名定义

typedef BottomFormatter = String? Function(DayType? dayType, DateTime date)?;
typedef RangePrompt = void Function(int i)?;
typedef ConfirmCallback = void Function(List<DateTime> list)?;