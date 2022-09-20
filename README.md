# list_calendar

Flutter 列表类型日期选择器

具备的功能单个日期选择、多个日期选择、日期范围选择，第一行和第二行文字分别是公历和农历(节日)，这个值是固定的不提供修改，第三行文字属于状态提醒，可外部配置修改。

完美支持Android Ios 理论上也能支持web，不过flutter不符合web生态，强行跨段适得其反！

在学习flutter的时候，发现官方的日期选择不太符合国内的用户操作习惯，第一反应就是自己开发一款方便后续项目使用。但是当时水平有限，对fluter的了解还不够，直到这几天感觉够了，时间上也允许我这么做，于是乎 list_calendar 就诞生了。

经过大量调研，国内的日期选择，无论是h5移动端各种开源ui库里面的日期筛选，还是app(各类订票软件，酒店入住)里面常用的日期筛选交互方式，基本都是列表展现形式，可以上下直接滑动，有一个日期范围供用户直观的选择。

如发现bug请提出来，或者是新的需求(时间允许的情况下，会斟酌更新)  ，希望能够给各位小伙伴带来一定的便利，如果对您有用还请手下留星，感激不尽！

## 安装

Terminal:

```shell
 $ flutter pub add list_calendar
```

或者在 pubspec.yaml 里面写入如下包名(并运行 `flutter pub get`):

```yaml
dependencies:
  list_calendar: ^1.0.0
```

## 使用
tips:  
只体现了部分核心代码，具体用法请查看example，参数说明请查看底部props表。

```dart
import 'package:list\_calendar/list\_calendar.dart';

//简单使用
showDialog<List<DateTime>>(  
  context: context,  
  barrierDismissible: false,  
  useSafeArea: false,  
  builder: (context) {  
    return ListCalendar(  
      type: SelectType.single,  
    );  
  },  
);

//使用蓝色主题
showDialog<List<DateTime>>(  
  context: context,  
  barrierDismissible: false,  
  useSafeArea: false,  
  builder: (context) {  
    return ListCalendarTheme(  
      child: ListCalendar(  
        type: SelectType.multiple,  
      ),  
    );  
  },  
);

//自定义主题
ListCalendarTheme(  
  headBackgroundColor: Colors.green,  
  confirmBackgroundColor: Colors.green,  
  selectedBackgroundColor: Colors.green,  
  middleBackgroundColor: Colors.green[100],  
  middleForegroundColor: Colors.green,  
  weekendColor: Colors.green,  
  child: ListCalendar(  
    type: SelectType.range,  
    initialDate: dateList3.map((String e) => DateTime.tryParse(e)!).toList(),  
    onConfirm: (list){  
      setState((){  
        dateList3 = list.map((DateTime e) => DateFormat('yyyy-MM-dd').format(e)).toList();  
      });  
    },  
    // 根据状态配置第三行文字  
    bottomFormatter: (dayType, date) {  
      if(dayType == DayType.start){  
        return  "入住";  
      }  
      if(dayType == DayType.middle){  
        return  "继续住着";  
      }  
      if(dayType == DayType.end){  
        return  "离开";  
      }  
    },  
  ),  
);
```


#### Props

| 参数 | 说明 | 类型 | 默认值 |
| --- | --- | --- | --- |
| type | 选择类型(single单个日期,multiple多个日期,range日期区间) | SelectType | SelectType.single |
| firstDate | 可选择的最小日期 | DateTime | 当天日期 |
| lastDate | 可选择的最大日期 | DateTime | 当天日期往后延6个月 |
| initialDate | 默认选中日期(传入[null] 表示默认不选择) | List<DateTime>? | 今天日期 |
| bottomFormatter | 底部第三行文字配置(可以根据这个函数里面的date,type重新设置第三行文字) | String? Function(DayType? dayType, DateTime date)? |  |
| allowSameDay | 是否允许日期范围的起止时间为同一天 | boolean | false |
| maxRange | 日期区间或多选最多可选天数 | int |  30 |
| rangePrompt | 区间选择超过最大值触发,外部可以结合其他ui库提示 | void  Function(int i)? |  |
| confirmText | 底部按钮文字 | String | 确定 |
| confirmDisabledText | 底部按钮禁用文字 | String | 确定 |
| onConfirm | 确认选择后触发的回调 | void Function(List<DateTime> list)? |  |
