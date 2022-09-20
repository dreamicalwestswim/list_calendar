/// 节日数据模型

class Festivals{
  Map<int, Map<int, String>> solar;
  Map<int, Map<int, String>> lunar;

  Festivals({
    required this.solar,
    required this.lunar,
  });
}