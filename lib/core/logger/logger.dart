import 'package:eat_easy_assignment/core/utils/imports.dart';

class Logger {
  static void log(String message, {LogType type = LogType.debugPrint}) {
    final colorCode = _getColorCode(type);
    debugPrint('$colorCode[${type.name.toUpperCase()}]: $message\x1B[0m');
  }

  static String _getColorCode(LogType type) {
    switch (type) {
      case LogType.error:
        return '\x1B[31m'; // Red
      case LogType.success:
        return '\x1B[32m'; // Green
      case LogType.info:
        return '\x1B[37m'; // White
      case LogType.warning:
        return '\x1B[33m'; // Yellow
      case LogType.debugPrint:
        return '\x1B[33m'; //Yellow
      default:
        return ''; // No color
    }
  }
}

enum LogType { error, success, info, warning, debugPrint }
