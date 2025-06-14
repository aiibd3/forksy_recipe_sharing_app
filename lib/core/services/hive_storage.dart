import 'package:hive_flutter/adapters.dart';
import 'package:forksy/core/utils/logs_manager.dart';

class HiveStorage {
  static Box? _appBox;
  static Box? _userBox;

  static Future<void> init() async {
    try {
      await Hive.initFlutter();

      _appBox = await Hive.openBox('app');
      _userBox = await Hive.openBox('userBox');

      LogsManager.info('Hive initialized successfully with appBox and userBox');
    } catch (e, stackTrace) {
      LogsManager.error('Error initializing Hive: $e\n$stackTrace');
      rethrow;
    }
  }

  static bool isFirstTime() {
    try {
      if (_appBox == null) {
        LogsManager.warning('appBox is null, Hive may not be initialized');
        return true;
      }
      final value = _appBox!.get('isFirstTime', defaultValue: null);
      if (value == null) {
        _appBox!.put('isFirstTime', false).then((_) {
          LogsManager.info('isFirstTime set to false');
        });
        return true;
      }
      return false;
    } catch (e, stackTrace) {
      LogsManager.error('Error checking isFirstTime: $e\n$stackTrace');
      return true;
    }
  }

  static Future<void> clearUserData() async {
    try {
      if (_userBox == null) {
        _userBox = await Hive.openBox('userBox');
        LogsManager.warning('userBox was null, opened it in clearUserData');
      }
      await _userBox!.clear();
      LogsManager.info('User data cleared from userBox');
    } catch (e, stackTrace) {
      LogsManager.error('Error clearing userBox: $e\n$stackTrace');
      rethrow;
    }
  }
}