import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:rfid/core/constants/constants.dart';
import 'package:rfid/core/extension/extension.dart';

class LocalSource {
  LocalSource(this.box);

  final Box<dynamic> box;

  /// locale
  Future<void> setLocale(String locale) async => box.put(HiveKeys.locale, locale);

  String? get getLocale => box.get(HiveKeys.locale, defaultValue: 'uz-uz');

  /// theme
  Future<void> setTheme(String theme) async => box.put(HiveKeys.theme, theme);

  ThemeMode get getTheme => (box.get(HiveKeys.theme, defaultValue: 'system') as String?).themeMode;

  /// user token
  Future<void> setUserToken(String token) async => box.put('auth_token', token);

  String get getUserToken => (box.get('auth_token', defaultValue: '') as String?) ?? '';

  Future<void> clearUserData() async {
    await box.delete('auth_token');
  }
}
