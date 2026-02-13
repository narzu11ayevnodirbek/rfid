import 'package:flutter/material.dart';
import 'package:rf_id_test/core/extention/extension.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    this.title = '',
    this.action,
    this.backgroundColor,
    this.backButtonEnabled = true,
    this.isBottomSheet = false,
    this.shape = BoxShape.circle,
  });

  final String title;
  final List<Widget>? action;
  final BoxShape shape;

  final Color? backgroundColor;
  final bool backButtonEnabled;
  final bool isBottomSheet;

  @override
  Widget build(BuildContext context) => AppBar(
        titleSpacing: 0,
        backgroundColor: backgroundColor ??
            (title == '' ? context.colorScheme.surface : null),
        title: Text(title),
        shape: shape == BoxShape.circle
            ? const RoundedRectangleBorder()
            : const ContinuousRectangleBorder(),
        scrolledUnderElevation: 0,

        automaticallyImplyLeading: false,
        // leadingWidth: 72,
        // leading: backButtonEnabled
        //     ? IconButton(
        //         onPressed: () => Navigator.pop(context),
        //         icon: Icon(isBottomSheet ? Icons.close : Icons.arrow_back_ios_new),
        //       )
        //     : null,
        actions: action,
        centerTitle: true,
      );

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
