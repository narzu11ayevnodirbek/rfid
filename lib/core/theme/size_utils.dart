part of 'themes.dart';

const kSpacer = Spacer();

const kGap = Gap(0);
const kGap4 = Gap(4);
const kGap6 = Gap(6);
const kGap8 = Gap(8);
const kGap12 = Gap(12);
const kGap20 = Gap(20);
const kGap24 = Gap(24);
const kGap40 = Gap(40);

/// sliver gap
const kSliverGap4 = SliverGap(4);
const kSliverGap6 = SliverGap(6);
const kSliverGap8 = SliverGap(8);
const kSliverGap10 = SliverGap(10);
const kSliverGap12 = SliverGap(12);
const kSliverGap16 = SliverGap(16);
const kSliverGap20 = SliverGap(20);
const kSliverGap24 = SliverGap(24);
const kSliverGap40 = SliverGap(40);

/// box
const kBoxShrink = SizedBox.shrink();
const kBoxWidth2 = SizedBox(width: 2);
const kBoxWidth4 = SizedBox(width: 4);
const kBoxWidth5 = SizedBox(width: 5);
const kBoxWidth6 = SizedBox(width: 6);
const kBoxWidth8 = SizedBox(width: 8);
const kBoxWidth10 = SizedBox(width: 10);
const kBoxWidth12 = SizedBox(width: 12);
const kBoxWidth14 = SizedBox(width: 14);
const kBoxWidth16 = SizedBox(width: 16);
const kBoxWidth20 = SizedBox(width: 20);
const kBoxWidth24 = SizedBox(width: 24);
const kBoxHeight2 = SizedBox(height: 2);
const kBoxHeight4 = SizedBox(height: 4);
const kBoxHeight6 = SizedBox(height: 6);
const kBoxHeight8 = SizedBox(height: 8);
const kBoxHeight10 = SizedBox(height: 10);
const kBoxHeight12 = SizedBox(height: 12);
const kBoxHeight16 = SizedBox(height: 16);
const kBoxHeight14 = SizedBox(height: 14);
const kBoxHeight20 = SizedBox(height: 20);
const kBoxHeight24 = SizedBox(height: 24);
const kBoxHeight32 = SizedBox(height: 32);
const kBoxHeight34 = SizedBox(height: 34);
const kBoxHeight36 = SizedBox(height: 36);
const kBoxHeight42 = SizedBox(height: 42);

/// padding
const kPadding0 = EdgeInsets.zero;
const kPaddingAll2 = EdgeInsets.all(2);
const kPaddingAll4 = EdgeInsets.all(4);
const kPaddingAll5 = EdgeInsets.all(5);
const kPaddingAll6 = EdgeInsets.all(6);
const kPaddingAll8 = EdgeInsets.all(8);
const kPaddingAll10 = EdgeInsets.all(10);
const kPaddingAll12 = EdgeInsets.all(12);
const kPaddingAll16 = EdgeInsets.all(16);
const kPaddingAll24 = EdgeInsets.all(24);
const kPaddingHorizontal4 = EdgeInsets.symmetric(horizontal: 4);
const kPaddingHorizontal6 = EdgeInsets.symmetric(horizontal: 6);
const kPaddingHorizontal8 = EdgeInsets.symmetric(horizontal: 8);
const kPaddingHorizontal12 = EdgeInsets.symmetric(horizontal: 12);
const kPaddingHorizontal16 = EdgeInsets.symmetric(horizontal: 16);
const kPaddingHorizontal20 = EdgeInsets.symmetric(horizontal: 20);
const kPaddingHorizontal32 = EdgeInsets.symmetric(horizontal: 32);
const kPaddingHor12Ver16 = EdgeInsets.symmetric(horizontal: 12, vertical: 16);
const kPaddingHor12Ver8 = EdgeInsets.symmetric(horizontal: 12, vertical: 8);
const kPaddingHor12Ver4 = EdgeInsets.symmetric(horizontal: 12, vertical: 4);
const kPaddingHor32Ver20 = EdgeInsets.symmetric(horizontal: 32, vertical: 20);
const kPaddingT20LRB16 = EdgeInsets.fromLTRB(20, 16, 16, 16);
const kPaddingBottom2 = EdgeInsets.only(bottom: 2);
const kPaddingBottom4 = EdgeInsets.only(bottom: 4);
const kPaddingBottom12 = EdgeInsets.only(bottom: 12);
const kPaddingBottom16 = EdgeInsets.only(bottom: 16);
const kPaddingTop2 = EdgeInsets.only(top: 2);
const kPaddingTop4 = EdgeInsets.only(top: 4);
const kPaddingTop12 = EdgeInsets.only(top: 12);
const kPaddingTop16 = EdgeInsets.only(top: 16);
const kPaddingHor14Ver16 = EdgeInsets.symmetric(horizontal: 14, vertical: 16);
const kPaddingHor16Ver4 = EdgeInsets.symmetric(horizontal: 16, vertical: 4);
const kPaddingHor16Ver6 = EdgeInsets.symmetric(horizontal: 16, vertical: 6);
const kPaddingHor16Ver8 = EdgeInsets.symmetric(horizontal: 16, vertical: 8);
const kPaddingHor16Ver12 = EdgeInsets.symmetric(horizontal: 16, vertical: 12);
const kPaddingHor16Ver24 = EdgeInsets.symmetric(horizontal: 16, vertical: 24);
const kPaddingHor8Ver4 = EdgeInsets.symmetric(horizontal: 8, vertical: 4);
const kPaddingHor8Ver6 = EdgeInsets.symmetric(horizontal: 8, vertical: 6);
const kPaddingVertical4 = EdgeInsets.symmetric(vertical: 4);
const kPaddingVertical6 = EdgeInsets.symmetric(vertical: 6);
const kPaddingVertical8 = EdgeInsets.symmetric(vertical: 8);
const kPaddingVertical12 = EdgeInsets.symmetric(vertical: 12);
const kPaddingVertical16 = EdgeInsets.symmetric(vertical: 16);
const kPaddingVertical24 = EdgeInsets.symmetric(vertical: 24);
const kPaddingAllB16 = EdgeInsets.fromLTRB(16, 16, 16, 0);
const kPaddingAll16T8B0 = EdgeInsets.fromLTRB(16, 8, 16, 0);
const kPaddingAll16T8B8 = EdgeInsets.fromLTRB(16, 8, 16, 8);
const kPaddingAllT8 = EdgeInsets.fromLTRB(8, 0, 8, 8);
const kPaddingAllB8 = EdgeInsets.fromLTRB(8, 8, 8, 0);
const kPaddingLeft16Top0Right16Bottom12 = EdgeInsets.fromLTRB(16, 0, 16, 12);
const kPaddingCardItemWithDivider = EdgeInsets.fromLTRB(16, 12, 12, 4);

EdgeInsets kPadding12AvoidBottom(BuildContext context) =>
    EdgeInsets.fromLTRB(12, 12, 12, 12 + context.padding.bottom);

EdgeInsets kPadding12AvoidTop(BuildContext context) =>
    EdgeInsets.fromLTRB(12, 12 + context.padding.top, 12, 12);

EdgeInsets kPadding8AvoidBottom(BuildContext context) =>
    EdgeInsets.fromLTRB(8, 8, 8, 8 + context.padding.bottom);

EdgeInsets kPadding8AvoidTop(BuildContext context) =>
    EdgeInsets.fromLTRB(8, 8 + context.padding.top, 8, 8);

/// border radius
const kRadius = Radius.zero;
const kRadius8 = Radius.circular(8);
const kRadius12 = Radius.circular(12);
const kRadius16 = Radius.circular(16);
const kRadius24 = Radius.circular(24);
const kBorderRadius2 = BorderRadius.all(Radius.circular(2));
const kBorderRadius4 = BorderRadius.all(Radius.circular(4));
const kBorderRadius7 = BorderRadius.all(Radius.circular(7));
const kBorderRadius8 = BorderRadius.all(Radius.circular(8));
const kBorderRadius9 = BorderRadius.all(Radius.circular(9));
const kBorderRadius10 = BorderRadius.all(Radius.circular(10));
const kBorderRadius12 = BorderRadius.all(Radius.circular(12));
const kBorderRadius16 = BorderRadius.all(Radius.circular(16));
const kBorderRadius24 = BorderRadius.all(Radius.circular(24));
const kBorderRadius50 = BorderRadius.all(Radius.circular(50));
const kBorderRadius100 = BorderRadius.all(Radius.circular(100));
const kBorderRadiusVerticalTop12 = BorderRadius.only(
  topRight: Radius.circular(12),
  topLeft: Radius.circular(12),
);
const kBorderRadiusVerticalBottom12 = BorderRadius.only(
  bottomRight: Radius.circular(12),
  bottomLeft: Radius.circular(12),
);

const kShapeRoundedNone = RoundedRectangleBorder();
const kShapeRoundedAll12 = RoundedRectangleBorder(
  borderRadius: BorderRadius.all(Radius.circular(12)),
);

ShapeBorder kShapeRoundedFull(BuildContext context) => RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(1.screenWidth(context))),
    );
const kShapeRoundedAll10 = RoundedRectangleBorder(
  borderRadius: BorderRadius.all(Radius.circular(10)),
);
const kShapeRoundedBottom12 = RoundedRectangleBorder(
  borderRadius: kBorderRadiusVerticalBottom12,
);
const kShapeRoundedTop12 = RoundedRectangleBorder(
  borderRadius: kBorderRadiusVerticalTop12,
);

/// grid
SliverGridDelegate itemGridDelegate(BuildContext context) =>
    SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      childAspectRatio: 0.55 / context.textScaleFactor,
    );

double kButtonDefaultPadding(BuildContext context) {
  final style = context.theme.elevatedButtonTheme.style;
  final padding = style?.padding?.resolve({});

  return padding?.vertical ?? 0;
}
