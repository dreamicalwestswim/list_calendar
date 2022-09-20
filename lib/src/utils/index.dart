import 'dart:async';

/// 函数防抖
/// 在触发事件时，不立即执行目标操作，而是给出一个延迟的时间，在该时间范围内如果再次触发了事件，则重置延迟时间，直到延迟时间结束才会执行目标操作。
/// [func]: 要执行的方法
/// [delay]: 要迟延的时长
/// debounce(() {
///   // 业务代码
/// })
Function debounce(
    Function func, [
      Duration delay = const Duration(milliseconds: 1000),
    ]) {
  Timer? timer;
  return (v) {
    if (timer?.isActive ?? false) {
      timer?.cancel();
    }
    timer = Timer(delay, () {
      func.call(v);
    });
  };
}

/// 函数节流
/// 在触发事件时，立即执行目标操作，同时给出一个延迟的时间，在该时间范围内如果再次触发了事件，该次事件会被忽略，直到超过该时间范围后触发事件才会被处理。
/// [func]: 要执行的方法
/// throttle(() async {
/// await Future.delayed(Duration(milliseconds: 2000));
/// // 业务代码
/// })
Function throttle(
    Future Function() func,
    ) {
  bool enable = true;
  return () {
    if (enable == true) {
      enable = false;
      func().then((_) {
        enable = true;
      });
    }
  };
}

