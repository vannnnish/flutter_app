// 缓存管理类

import 'package:shared_preferences/shared_preferences.dart';

class HiCache {
  SharedPreferences? prefs;

  HiCache._() {
    init();
  }

  static HiCache? _instance;

  static HiCache? getInstance() {
    _instance ??= HiCache._();
    return _instance;
  }

  static Future<HiCache?> preInit() async {
    if (_instance == null) {
      var prefs = await SharedPreferences.getInstance();
      _instance = HiCache._pre(prefs);
    }
    return _instance;
  }

  // 预处理化方法

  void init() async {
    prefs ??= await SharedPreferences.getInstance();
  }

  HiCache._pre(SharedPreferences this.prefs);

  setString(String key, String value) {
    prefs?.setString(key, value);
  }

  setDouble(String key, double value) {
    prefs?.setDouble(key, value);
  }

  setInt(String key, int value) {
    prefs?.setInt(key, value);
  }

  setBool(String key, bool value) {
    prefs?.setBool(key, value);
  }

  setStringList(String key, List<String> value) {
    prefs?.setStringList(key, value);
  }

  Object? get<T>(String key) {
    return prefs?.get(key);
  }
}
