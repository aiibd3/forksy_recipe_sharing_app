import 'dart:developer' as developer;

import 'package:logger/logger.dart';

class LogsManager {
  static final _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 2,
      errorMethodCount: 0,
      colors: true,
      printEmojis: true,
      noBoxingByDefault: true,
    ),
    filter: null,
    output: null,
  );

  static void debug(dynamic message) {
    _logger.d(message);
  }

  static void info(dynamic message, {String name = 'INFO'}) {
    _log(message, name: name, level: 0);
  }

  static void warning(dynamic message, {String name = 'WARNING'}) {
    _logger.w(message);
  }

  static void error(dynamic message, {String name = 'ERROR'}) {
    _logger.w(message);
  }

  static void printWithoutColors(dynamic message, String name) {
    _log(message, name: name, level: 0);
  }

  static void _log(dynamic message,
      {required String name, required int level}) {
    developer.log(message.toString(), name: name, level: level);
  }
}
