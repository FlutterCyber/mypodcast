import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveDBNotifications {
  static Box<String> notifications_box = Hive.box<String>("notifications_id");

  static Listenable get podcastListenable => notifications_box.listenable();

  static Future<void> saveId(String id) async {
    return await notifications_box.put(id, id);
  }

  static Future<void> saveOne() async {
    return await notifications_box.put(1, "1");
  }

  static Future<String> getId(String id) async {
    return notifications_box.get(id).toString();
  }

  static Future<void> deleteId(String id) async {
    await notifications_box.delete(id);
  }

  static Iterable<String> getAllId() {
    return notifications_box.values;
  }
}
