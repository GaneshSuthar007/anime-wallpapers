import 'package:logger/logger.dart';

class DefaultException implements Exception {
  final String message;
  final StackTrace? stackTrace;
  DefaultException({
    this.message = 'No internet connection.',
    this.stackTrace,
  }) {
    Logger().e(stackTrace);
  }

  @override
  String toString() => message;
}
