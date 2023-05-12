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
  Logger logger = Logger();

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
