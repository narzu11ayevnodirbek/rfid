part of 'extension.dart';

enum CardTypes { uzcard, humo, visa, mastercard, unionpay, mir }

extension StringExtensions on String {
  bool getCardIcon(CardTypes type) {
    switch (type) {
      case CardTypes.uzcard:
        return startsWith(RegExp('^(5614|8600)'));
      case CardTypes.humo:
        return startsWith(RegExp('^(9860)'));
      case CardTypes.visa:
        return startsWith(RegExp('4'));
      case CardTypes.mastercard:
        return startsWith(RegExp('^(2720|2221|51|55)'));
      case CardTypes.unionpay:
        return startsWith(RegExp('^(62)'));
      case CardTypes.mir:
        return startsWith(RegExp('^(2200|2204)'));
    }
  }

  String get fromSpaceFormat => replaceAll(' ', '');

  bool get phoneNumbIsValid {
    if (isEmpty) return false;
    final RegExp regex = RegExp(r'^\+998\d{9}$');
    return regex.hasMatch(this);
  }

  String get toPhoneFormat {
    String newText = replaceAll(RegExp(r'[^+\d]'), '');

    const List<int> spacingIndices = [4, 7, 11, 14];

    for (final i in spacingIndices) {
      if (newText.length > i) newText = '${newText.substring(0, i)} ${newText.substring(i)}';
    }

    return newText;
  }

  int get parseToInt => int.tryParse(this) ?? 0;
}
