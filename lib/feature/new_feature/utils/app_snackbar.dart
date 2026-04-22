// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// class AppSnackbar {
//   AppSnackbar._();
//
//   static const EdgeInsets _margin =
//   EdgeInsets.symmetric(horizontal: 16, vertical: 24);
//
//   /// Har safar yangi snackbar chiqishidan oldin eskilarini yopib tashlaydi
//   static void _show(
//       String title,
//       String message, {
//         required Color bg,
//         Duration duration = const Duration(seconds: 2),
//       }) {
//     // ✅ Queue bo‘lmasin, darhol yangilansin
//     if (Get.isSnackbarOpen) {
//       Get.closeAllSnackbars(); // yoki Get.closeCurrentSnackbar();
//     }
//
//     Get.snackbar(
//       title,
//       message,
//       snackPosition: SnackPosition.TOP,
//       duration: duration,
//       margin: _margin,
//       backgroundColor: bg,
//       colorText: Colors.white,
//
//       // ✅ “sekin chiqib-kirish”ni yo‘qotamiz
//       animationDuration: Duration.zero,
//       forwardAnimationCurve: Curves.linear,
//       reverseAnimationCurve: Curves.linear,
//
//       // ixtiyoriy: swipe bilan yopish
//       dismissDirection: DismissDirection.up,
//       isDismissible: true,
//     );
//   }
//
//   static void showSuccess(String title, String message) {
//     _show(title, message, bg: Colors.green.shade700, duration: Duration(seconds: 3));
//   }
//
//   static void showError(String title, String message) {
//     _show(title, message, bg: Colors.red.shade700, duration: const Duration(seconds: 3));
//   }
//
//   static void showInfo(String title, String message) {
//     _show(title, message, bg: Colors.grey.shade800, duration: const Duration(seconds: 3));
//   }
//
//   /// RFID uchun maxsus: juda ko‘p chaqirilganda ham “instant replace”
//   static void showRfid(String epc) {
//     _show('RFID', 'Метка: $epc', bg: Colors.grey.shade900, duration: const Duration(milliseconds: 3000));
//   }
// }

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppSnackbar {
  AppSnackbar._();

  static const EdgeInsets _margin =
  EdgeInsets.symmetric(horizontal: 16, vertical: 24);

  static Timer? _rfidTimer;
  static String _lastRfidMessage = '';
  static int _serial = 0;

  static void _show(
      String title,
      String message, {
        required Color bg,
        Duration duration = const Duration(seconds: 2),
      }) {
    final int current = ++_serial;

    if (Get.isSnackbarOpen) {
      Get.closeAllSnackbars();
    }

    Future.delayed(Duration.zero, () {
      if (current != _serial) return;

      Get.rawSnackbar(
        titleText: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        messageText: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
        snackPosition: SnackPosition.TOP,
        duration: duration,
        margin: _margin,
        backgroundColor: bg,
        borderRadius: 8,
        animationDuration: Duration.zero,
        forwardAnimationCurve: Curves.linear,
        reverseAnimationCurve: Curves.linear,
        dismissDirection: DismissDirection.up,
        // isDismissible: true
      );
    });
  }

  static void showSuccess(String title, String message) {
    _show(
      title,
      message,
      bg: Colors.green.shade700,
      duration:  Duration(seconds: 2),
    );
  }

  static void showError(String title, String message) {
    _show(
      title,
      message,
      bg: Colors.red.shade700,
      duration: const Duration(seconds: 3),
    );
  }

  static void showInfo(String title, String message) {
    _show(
      title,
      message,
      bg: Colors.grey.shade800,
      duration:  Duration(seconds: 2),
    );
  }

  static void showRfid(String epc) {
    final msg = 'Метка: $epc';

    if (_lastRfidMessage == msg) return;
    _lastRfidMessage = msg;

    _rfidTimer?.cancel();
    _rfidTimer = Timer(const Duration(milliseconds: 80), () {
      _show(
        'RFID',
        _lastRfidMessage,
        bg: Colors.grey.shade900,
        duration: const Duration(milliseconds: 900),
      );
    });
  }

  static void close() {
    _rfidTimer?.cancel();
    _lastRfidMessage = '';
    Get.closeAllSnackbars();
  }
}