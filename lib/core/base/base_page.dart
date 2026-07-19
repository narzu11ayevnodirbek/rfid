// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:keyboard_dismisser/keyboard_dismisser.dart';
// import 'package:rfid/feature/components/loading_view.dart';
//
// import 'base_state.dart';
//
// abstract class BasePage<CUBIT extends Cubit<BaseState<BUILDABLE, LISTENABLE>>, BUILDABLE,
//     LISTENABLE> extends StatefulWidget {
//   const BasePage({super.key});
//
//   Widget builder(BuildContext context, BUILDABLE state);
//
//   void listener(BuildContext context, LISTENABLE state) {}
//
//   void init(BuildContext context) {}
//
//   void onFocusGained(BuildContext context) {}
//
//   void dispose() {}
//
//   Widget loadable({
//     required bool loading,
//     Widget? loadingView,
//     required bool error,
//     VoidCallback? retry,
//     required Widget Function() builder,
//   }) {
//     if (loading) return loadingView ?? const LoadingView();
//     if (error) {
//       // return Builder(builder: (context) {
//       //   return ErrorView(retry: () => retry == null ? init(context) : retry());
//       // });
//     }
//     return builder();
//   }
//
//   @override
//   State<BasePage> createState() => _BasePageState<CUBIT, BUILDABLE, LISTENABLE>();
// }
//
// class _BasePageState<CUBIT extends Cubit<BaseState<BUILDABLE, LISTENABLE>>, BUILDABLE, LISTENABLE>
//     extends State<BasePage> {
//   bool initialized = false;
//
//   @override
//   void dispose() {
//     super.dispose();
//     widget.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     bool lost = false;
//     return KeyboardDismisser(
//       child: BlocProvider<CUBIT>(
//         create: (_) => getIt<CUBIT>(),
//         child: Builder(
//           builder: (context) {
//             if (!initialized) {
//               widget.init(context);
//               initialized = true;
//             }
//             return FocusDetector(
//               onFocusGained: () {
//                 if (!lost) return;
//                 widget.onFocusGained(context);
//               },
//               onFocusLost: () => lost = true,
//               child: BaseListener<CUBIT, BUILDABLE, LISTENABLE>(
//                 listener: (listenable) => widget.listener(context, listenable),
//                 child: BaseBuilder<CUBIT, BUILDABLE, LISTENABLE>(builder: widget.builder),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
