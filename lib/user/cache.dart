import 'package:hive/hive.dart';

import 'model.dart';

const _name = "user_cache";

class UserCache {
  static Future<Box> instance() async {
    var i = Hive.box(_name);
    if (!i.isOpen) {
      return Hive.openBox(_name);
    }
    return i;
  }

  static Future<void> put(String key, User value) async {
    var i = await UserCache.instance();
    return i.put(key, value);
  }

  static Future<User> get(String key, User defaultValue) async {
    var i = await UserCache.instance();
    return i.get(key, defaultValue: defaultValue);
  }
}
