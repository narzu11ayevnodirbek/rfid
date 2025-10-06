import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:rf_id_test/core/l10n/app_localizations.dart';
import 'package:rf_id_test/core/theme/themes.dart';

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
