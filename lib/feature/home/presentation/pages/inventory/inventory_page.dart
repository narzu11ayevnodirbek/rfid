// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:rf_id_test/core/enums/status_enums.dart';
// import 'package:rf_id_test/core/extension/extension.dart';
// import 'package:rf_id_test/feature/components/custom_app_bar.dart';
// import 'package:rf_id_test/feature/components/loading_view.dart';
// import 'package:rf_id_test/feature/home/presentation/bloc/inventory/inventory_bloc.dart';
// import 'package:rf_id_test/feature/home/presentation/pages/inventory/widget/inventory_item.dart';
// import 'package:rf_id_test/feature/home/presentation/pages/inventory_create/inventory_create_page.dart';

// part 'mixin/inventory_mixin.dart';

// class InventoryPage extends StatefulWidget {
//   const InventoryPage({super.key});

//   @override
//   State<InventoryPage> createState() => _InventoryPageState();
// }

// class _InventoryPageState extends State<InventoryPage> with InventoryMixin {
//   @override
//   Widget build(BuildContext context) => CupertinoPageScaffold(
//         child: Scaffold(
//           appBar: const CustomAppBar(
//             title: 'Инвентаризация',
//             action: [
//               // BlocSelector<InventoryBloc, InventoryState, bool>(
//               //   selector: (state) => state.inventoryList.isEmpty || state.status.isLoading,
//               //   builder: (context, isDisabled) => IconButton(
//               //     onPressed: isDisabled
//               //         ? null
//               //         : () {
//               //             showCupertinoSheet<dynamic>(
//               //               context: context,
//               //               pageBuilder: (context) => const InventoryCreatePage(
//               //                 args: InventoryCreateArgs(),
//               //               ),
//               //             );
//               //           },
//               //     icon: const Icon(Icons.add),
//               //   ),
//               // )
//             ],
//           ),
//           body: BlocBuilder<InventoryBloc, InventoryState>(
//             buildWhen: (oldState, newState) {
//               if (oldState.status.isLoading && newState.status.isError) {
//                 EasyLoading.showError(newState.message);
//               }
//               return true;
//             },
//             builder: (context, state) => RefreshIndicator(
//               onRefresh: _onRefresh,
//               child: Stack(
//                 children: [
//                   CustomScrollView(
//                     controller: _scrollController,
//                     physics: const AlwaysScrollableScrollPhysics(),
//                     slivers: [
//                       12.kSliverGap,
//                       if (state.inventoryList.isNotEmpty)
//                         SliverPadding(
//                           padding: 16.kPaddingHorizontal,
//                           sliver: SliverList.separated(
//                             itemCount: state.inventoryList.length,
//                             itemBuilder: (context, index) {
//                               final item = state.inventoryList[index];
//                               return InventoryItem(
//                                 item: item,
//                                 onTap: () {
//                                   showCupertinoSheet<void>(
//                                     context: context,
//                                     pageBuilder: (context) => Scaffold(
//                                       appBar: CustomAppBar(
//                                         title: 'cuper',
//                                       ),
//                                       body: Center(
//                                         child: Text('data'),
//                                       ),
//                                     ),
//                                   );
//                                 },
//                               );
//                             },
//                             separatorBuilder: (_, __) => 12.kBoxHeight,
//                           ),
//                         ),
//                       if (state.inventoryList.isEmpty &&
//                           !state.status.isLoading)
//                         const SliverFillRemaining(
//                             child: Center(child: Text('List is empty'))),
//                       12.kSliverGap,
//                     ],
//                   ),
//                   if (state.status.isLoading)
//                     const LoadingView(withOpacityBackground: true),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       );
// }
