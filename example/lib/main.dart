import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:list_calendar/list_calendar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'ListCalendar 使用栗子'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> dateList = [];
  List<String> dateList2 = [];
  List<String> dateList3 = [];

  Future _showCalendar() async{
    var res = await showDialog<List<DateTime>>(
      context: context,
      barrierDismissible: false,
      useSafeArea: false,
      builder: (context) {
        return ListCalendar(
          type: SelectType.single,
          initialDate: dateList.map((String e) => DateTime.tryParse(e)!).toList(),
          onConfirm: (list){
            setState((){
              dateList = list.map((DateTime e) => DateFormat('yyyy-MM-dd').format(e)).toList();
            });
          },
        );
      },
    );
  }

  Future _showCalendar2() async{
    var res = await showDialog<List<DateTime>>(
      context: context,
      barrierDismissible: false,
      useSafeArea: false,
      builder: (context) {
        return ListCalendarTheme(
          child: ListCalendar(
            type: SelectType.multiple,
            initialDate: dateList2.map((String e) => DateTime.tryParse(e)!).toList(),
            // 选择数量超过限制会触发
            rangePrompt: (int v){
              print(v);
            },
            onConfirm: (list){
              setState((){
                dateList2 = list.map((DateTime e) => DateFormat('yyyy-MM-dd').format(e)).toList();
              });

            },
          ),
        );
      },
    );
  }

  Future _showCalendar3() async{
    var res = await showDialog<List<DateTime>>(
      context: context,
      barrierDismissible: false,
      useSafeArea: false,
      builder: (context) {
        return ListCalendarTheme(
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
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          children: <Widget>[
            ...dateList.map((e) => Text("$e")).toList(),
            ElevatedButton(onPressed: (){
              _showCalendar();
            }, child: Text("单个日期选择(默认主题)")),
            ...dateList2.map((e) => Text("$e")).toList(),
            ElevatedButton(onPressed: (){
              _showCalendar2();
            }, child: Text("多个日期选择(蓝色主题)")),
            ...dateList3.map((e) => Text("$e")).toList(),
            ElevatedButton(onPressed: (){
              _showCalendar3();
            }, child: Text("日期范围选择(自定义主题)")),
          ],
        ),
      )
    );
  }
}
