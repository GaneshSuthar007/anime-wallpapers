import 'package:logger/logger.dart';

class InternetFailedException implements Exception {
  final String message;

  InternetFailedException({
    this.message = 'No internet connection.!',
  }) {
    Logger().w(message);
  }

  @override
  String toString() => message;
}
