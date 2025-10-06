import 'package:flutter/material.dart';
import 'package:rf_id_test/core/extention/extension.dart';
import 'package:rf_id_test/core/theme/themes.dart';

class SliverListEmpty extends StatelessWidget {
  const SliverListEmpty({super.key, this.message = 'empty_message'});

  final String message;

  @override
  Widget build(BuildContext context) => SafeArea(
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverFillRemaining(
              child: Padding(
                padding: kPaddingAll12,
                child: Center(
                  child: Text(
                    message,
                    style: context.textStyle.regularCallout,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
}

// class SliverListNotFound extends StatelessWidget {
//   const SliverListNotFound({super.key, this.text});
//
//   final String? text;
//
//   @override
//   Widget build(BuildContext context) => SafeArea(
//         child: CustomScrollView(
//           physics: const AlwaysScrollableScrollPhysics(),
//           slivers: [
//             SliverFillRemaining(
//               child: Center(
//                 child: Padding(
//                   padding: kPaddingHorizontal20,
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Image.asset(
//                         ImagesConstants,
//                         width: 120,
//                         height: 120,
//                         fit: BoxFit.cover,
//                       ),
//                       kBoxHeight12,
//                       Text(
//                         text ?? context.translate('not_found'),
//                         style: context.textStyle.regularCallout,
//                         textAlign: TextAlign.center,
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       );
// }
