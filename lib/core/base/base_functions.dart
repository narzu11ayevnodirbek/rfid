import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';

class BaseSearchFilter extends Equatable {
  const BaseSearchFilter({
    required this.startDate,
    required this.endDate,
    required this.searchText,
  });

  final String startDate;
  final String endDate;
  final String searchText;

  BaseSearchFilter copyWith({
    final String? startDate,
    final String? endDate,
    final String? searchText,
  }) =>
      BaseSearchFilter(
        startDate: startDate ?? this.startDate,
        endDate: endDate ?? this.endDate,
        searchText: searchText ?? this.searchText,
      );

  @override
  List<Object> get props => [startDate, endDate, searchText];
}

void printOnDebug(Object? msg, {String key = 'key'}) {
  debugPrint('-------------\n$key: $msg\n-------------');
}

void printLog(Object? msg) {
  Logger().i(msg);
}

void jumpToFirstIndex(ScrollController controller) {
  unawaited(controller.animateTo(
    0,
    duration: const Duration(milliseconds: 250),
    curve: Curves.fastOutSlowIn,
  ));
}

int generateUniqueId = DateTime.now().millisecondsSinceEpoch ~/ 1000;
