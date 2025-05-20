import 'package:forksy/core/utils/logs_manager.dart';
import 'package:hive_flutter/adapters.dart';


class HiveStorage {
  HiveStorage._();

  static Box? appBox;

  static Future<void> init() async {
    appBox = await Hive.openBox('app');
  }

  static bool isFirstTime() {
    var value = appBox?.get("isFirstTime", defaultValue: null);

    if (value == null) {
      appBox?.put("isFirstTime", false).then((value) {
        LogsManager.info("isFirstTime: true");
      });
      return true;
    }
    return false;
  }
}
