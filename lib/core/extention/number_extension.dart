part of 'extension.dart';

extension NumberExtension on num {
  String get formatNum {
    if (this % 1 == 0) return toInt().toString();
    final String numString = toString();
    if (numString.substring(numString.indexOf('.')).length > 2) {
      return toStringAsFixed(2);
    } else {
      return numString;
    }
  }

  String get formatMoney {
    String text = formatNum.split('.').first;
    final List numberList = formatNum.split('.');
    final remains = text.length % 3;
    for (int i = text.length - (text.length % 3 + 3); i + remains > 0; i = i - 3) {
      text = text.replaceRange(i + remains, i + remains, ' ');
    }
    if (numberList.length > 1) {
      text = '$text.${numberList[1]}';
    }
    return text;
  }

  String get formatDecimalValue {
    if (this == toInt()) return toInt().toString();
    return toString();
  }
}
