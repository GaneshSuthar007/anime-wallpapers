import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SnackbarUtil {
  static void showSuccess({required String title , required String message}) {
    Get.rawSnackbar(
      title: title,
      icon: const Icon(Icons.thumb_up, color: Colors.white),
      message: message,
      backgroundColor: Colors.green.shade900,
    );
  }

  static void showWarning({required String message}) {
    Get.rawSnackbar(
      title: 'Warning',
      icon: const Icon(Icons.warning, color: Colors.white),
      message: message,
      backgroundColor: Colors.orange.shade900,
    );
  }

  static void showError({required String message}) {
    Get.rawSnackbar(
      title: 'Error',
      icon: const Icon(Icons.error, color: Colors.white),
      message: message,
      backgroundColor: Colors.redAccent.shade700,
    );
  }
}
