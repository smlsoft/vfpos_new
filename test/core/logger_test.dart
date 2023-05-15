import 'package:dedepos/core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';

void main() {
  setUpAll(() {
    Logger.level = Level.verbose;
    serviceLocator.registerSingleton<Log>(LogImpl());
  });

  test('test trace log', () {
    final logger = serviceLocator<Log>();
    logger.trace('trace message', error: 'error trace');
    expect(true, true);
  });

  test('test debug log', () {
    final logger = serviceLocator<Log>();
    logger.debug('debug message', error: 'debug error');
    expect(true, true);
  });

  test('test info log', () {
    final logger = serviceLocator<Log>();
    logger.info('info log message', error: 'info error title');
    expect(true, true);
  });

  test('test warn log', () {
    final logger = serviceLocator<Log>();
    logger.warn('warning log message', error: 'warning title');
    expect(true, true);
  });

  test('test error log', () {
    final logger = serviceLocator<Log>();
    logger.error('error log message', error: 'test error log');
    expect(true, true);
  });

  test('test danger failure log', () {
    final logger = serviceLocator<Log>();
    logger.dangerFailure('wtf log message', error: 'title');
    expect(true, true);
  });
}
