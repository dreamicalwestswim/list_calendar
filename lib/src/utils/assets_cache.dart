
/// 资源缓存
class AssetsCache {
  static final Map<String, dynamic> _assets = {};

  /// 从缓存中获取
  static T? getItem<T>(String name) {
    return _assets[name];
  }

  /// 设置缓存
  static T? setItem<T>(String name, dynamic asset) {
    _assets[name] = asset;
    return getItem<T>(name);
  }

  /// 从缓存中删除
  static void clear(String key) {
    _assets.remove(key);
  }

  /// 从缓存中删除所有
  static void clearCache() {
    _assets.clear();
  }

}