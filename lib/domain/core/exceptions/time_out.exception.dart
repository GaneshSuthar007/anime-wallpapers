import 'package:logger/logger.dart';

class TimeOutException implements Exception {
  final String message;
  TimeOutException({
    this.message = 'Request Timeout.',
  }) {
    Logger().w(message);
  }

  @override
  String toString() => message;
}
