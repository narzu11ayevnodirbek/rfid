part of 'extension.dart';

extension SizeExtension on BuildContext {
  bool get isMobile =>
      MediaQuery.of(this).size.width < 600 && (Platform.isAndroid || Platform.isIOS);

  bool get isTablet =>
      MediaQuery.of(this).size.width > 600 && (Platform.isAndroid || Platform.isIOS);

  double get doubleToWidth =>
      isMobile ? MediaQuery.of(this).size.width : (MediaQuery.of(this).size.width - 48) / 2;

  EdgeInsets get kMargin16 => EdgeInsets.only(
        top: MediaQuery.of(this).padding.top,
        left: isMobile ? 16 : 200,
        right: isMobile ? 16 : 200,
        bottom: MediaQuery.of(this).padding.bottom,
      );

  EdgeInsets get kMarginBottom16 => EdgeInsets.only(
        bottom: MediaQuery.of(this).padding.bottom,
        left: isMobile ? 16 : 200,
        right: isMobile ? 16 : 200,
      );

  Size get kSize => MediaQuery.of(this).size;

  Size get sizeOf => MediaQuery.sizeOf(this);

  Brightness get platformBrightnessOf => MediaQuery.platformBrightnessOf(this);

  EdgeInsets get viewInsetsOf => MediaQuery.viewInsetsOf(this);

  EdgeInsets get padding => MediaQuery.paddingOf(this);

  double get textScaleFactor => MediaQuery.of(this).textScaler.scale(1).clamp(1, 1.05);

  MediaQueryData get mediaQuery => MediaQuery.of(this);
}

extension OrientationExtension on Orientation {
  bool get isPortrait => this == Orientation.portrait;
}

extension BrightnessX on Brightness {
  bool get isDark => this == Brightness.dark;

  bool get isLight => this == Brightness.light;
}

extension SizeValueExt on num {
  double screenWidth(BuildContext context) => context.sizeOf.width * this;

  double screenHeight(BuildContext context) => context.sizeOf.height * this;
}

extension SizedBoxExt on num {
  SizedBox get kBoxHeight => SizedBox(height: toDouble());

  SizedBox get kBoxWidth => SizedBox(width: toDouble());

  Gap get kGap => Gap(toDouble());

  SliverGap get kSliverGap => SliverGap(toDouble());
}

extension PaddingExt on num {
  EdgeInsets get kPaddingAll => EdgeInsets.all(toDouble());

  EdgeInsets get kPaddingHorizontal => EdgeInsets.symmetric(horizontal: toDouble());

  EdgeInsets get kPaddingVertical => EdgeInsets.symmetric(vertical: toDouble());

  EdgeInsets get kPaddingOnlyTop => EdgeInsets.only(top: toDouble());

  EdgeInsets get kPaddingOnlyLeft => EdgeInsets.only(left: toDouble());

  EdgeInsets get kPaddingOnlyRight => EdgeInsets.only(right: toDouble());

  EdgeInsets get kPaddingOnlyBottom => EdgeInsets.only(bottom: toDouble());

  EdgeInsets kPaddingAllAvoidBottom(BuildContext context) =>
      EdgeInsets.fromLTRB(toDouble(), toDouble(), toDouble(), context.padding.bottom);

  EdgeInsets kPaddingAllAvoidTop(BuildContext context) =>
      EdgeInsets.fromLTRB(context.padding.top, toDouble(), toDouble(), toDouble());
}

const EdgeInsets kPadding12h8v = EdgeInsets.symmetric(horizontal: 12, vertical: 8);

extension BorderRadiusExt on num {
  Radius get kRadius => Radius.circular(toDouble());

  BorderRadius get kBorderRadiusAll => BorderRadius.all(kRadius);

  BorderRadius get kBorderRadiusOnlyTop => BorderRadius.vertical(top: kRadius);

  BorderRadius get kBorderRadiusOnlyBottom => BorderRadius.vertical(bottom: kRadius);

  RoundedRectangleBorder get kShapeRoundedAll => RoundedRectangleBorder(
        borderRadius: kBorderRadiusAll,
      );

  RoundedRectangleBorder get kShapeRoundedAllBottom => RoundedRectangleBorder(
        borderRadius: kBorderRadiusOnlyBottom,
      );

  RoundedRectangleBorder get kShapeRoundedAllTop => RoundedRectangleBorder(
        borderRadius: kBorderRadiusOnlyTop,
      );
}
