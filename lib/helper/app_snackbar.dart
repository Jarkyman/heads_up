import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppSnackbar {
  static final Map<String, DateTime> _lastShownAt = {};
  static String? _activeKey;

  static void showUnique({
    required String title,
    required String message,
    String? key,
    SnackPosition snackPosition = SnackPosition.BOTTOM,
    Color? backgroundColor,
    Color? colorText,
    Duration duration = const Duration(seconds: 3),
    Duration duplicateWindow = const Duration(seconds: 3),
  }) {
    final snackbarKey = key ?? '$title::$message';
    final now = DateTime.now();
    final lastShownAt = _lastShownAt[snackbarKey];
    final isDuplicateInWindow =
        lastShownAt != null && now.difference(lastShownAt) < duplicateWindow;

    if (_activeKey == snackbarKey || isDuplicateInWindow) {
      return;
    }

    _activeKey = snackbarKey;
    _lastShownAt[snackbarKey] = now;
    Get.closeAllSnackbars();

    Get.snackbar(
      title,
      message,
      snackPosition: snackPosition,
      backgroundColor: backgroundColor,
      colorText: colorText,
      duration: duration,
      snackbarStatus: (status) {
        if (status == SnackbarStatus.CLOSED && _activeKey == snackbarKey) {
          _activeKey = null;
        }
      },
    );
  }
}
