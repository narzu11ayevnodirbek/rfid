part of 'extension.dart';

extension ThemeStringExtension on String? {
  ThemeMode get themeMode => switch (this) {
        'light' => ThemeMode.light,
        'dark' => ThemeMode.dark,
        'system' => ThemeMode.system,
        String() => ThemeMode.system,
        null => ThemeMode.system,
      };
}

extension ThemeModelExtension on ThemeMode {
  bool get isLight => this == ThemeMode.light;

  bool get isDark => this == ThemeMode.dark;

  bool get isSystem => this == ThemeMode.system;

  String get themeModeText => switch (this) {
        ThemeMode.light => 'light',
        ThemeMode.dark => 'dark',
        ThemeMode.system => 'system',
      };
}
