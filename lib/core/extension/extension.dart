import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:rfid/core/theme/themes.dart';
import 'package:rfid/infrastructure/localization/app_localizations.dart';

part 'build_context_extension.dart';
part 'date_parse_extension.dart';
part 'number_extension.dart';
part 'size_extension.dart';
part 'string_extension.dart';
part 'theme_extentions.dart';

extension ListCustExt<T> on List<T> {
  T? firstWhereOrNull(bool Function(T element) test) {
    for (final element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}
