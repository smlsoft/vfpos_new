import 'package:logger/logger.dart';

abstract class Log {
  void trace(dynamic message, {dynamic error, StackTrace? stackTrace});
  void debug(dynamic message, {dynamic error, StackTrace? stackTrace});
  void info(dynamic message, {dynamic error, StackTrace? stackTrace});
  void warn(dynamic message, {dynamic error, StackTrace? stackTrace});
  void error(dynamic message, {dynamic error, StackTrace? stackTrace});
  void dangerFailure(dynamic message, {dynamic error, StackTrace? stackTrace});
}

class LogImpl implements Log {
  Logger logger = Logger(
    printer: PrettyPrinter(
      stackTraceBeginIndex: 1,
      methodCount: 2, // number of method calls to be displayed
      errorMethodCount: 8, // number of method calls if stacktrace is provided
      lineLength: 120, // width of the output
      colors: false, // Colorful log messages
      printEmojis: false, // Print an emoji for each log message
      printTime: false, // Should each log print contain a timestamp\
      noBoxingByDefault: true,
    ),
  );

  @override
  void trace(dynamic message, {dynamic error, StackTrace? stackTrace}) {
    logger.v(message, error, stackTrace);
  }

  @override
  void debug(dynamic message, {dynamic error, StackTrace? stackTrace}) {
    logger.d(message, error, stackTrace);
  }

  @override
  void info(dynamic message, {dynamic error, StackTrace? stackTrace}) {
    logger.i(message, error, stackTrace);
  }

  @override
  void warn(dynamic message, {dynamic error, StackTrace? stackTrace}) {
    logger.w(message, error, stackTrace);
  }

  @override
  void error(dynamic message, {dynamic error, StackTrace? stackTrace}) {
    logger.e(message, error, stackTrace);
  }

  @override
  void dangerFailure(dynamic message, {dynamic error, StackTrace? stackTrace}) {
    logger.wtf(message, error, stackTrace);
  }
}
