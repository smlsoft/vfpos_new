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
    logger.trace('trace #1', error: 'error trace title');
    expect(true, true);
  });

  test('test debug log', () {
    final logger = serviceLocator<Log>();
    logger.debug('test debug Log', error: 'debug error message');
    expect(true, true);
  });

  test('test info log', () {
    final logger = serviceLocator<Log>();
    logger.info('test info log', error: 'info error');
    expect(true, true);
  });

  test('test warn log', () {
    final logger = serviceLocator<Log>();
    logger.warn('test warning log', error: 'warning');
    expect(true, true);
  });

  test('test error log', () {
    final logger = serviceLocator<Log>();
    logger.error('test error log', error: 'test error log');
    expect(true, true);
  });

  test('test danger failure log', () {
    final logger = serviceLocator<Log>();
    logger.dangerFailure('test danger failure log', error: 'title');
    expect(true, true);
  });
}
