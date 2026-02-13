// import 'package:flutter/material.dart';
// import 'package:rf_id_test/feature/components/custom_app_bar.dart';

// class TransitionPage extends StatefulWidget {
//   const TransitionPage({super.key});

//   @override
//   State<TransitionPage> createState() => _TransitionPageState();
// }

// class _TransitionPageState extends State<TransitionPage> {
//   String _selectedAction = 'Hech narsa tanlanmagan';
//   @override
//   Widget build(BuildContext context) => Scaffold(
//         appBar: CustomAppBar(
//           title: 'Перемещение',
//           action: [
//             PopupMenuButton(
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               icon: const Icon(Icons.more_vert),
//               onSelected: (value) {
//                 setState(() {
//                   _selectedAction = value;
//                 });
//               },
//               itemBuilder: (context) => [
//                 const PopupMenuItem(
//                   value: 'history',
//                   child: Row(
//                     children: [
//                       Icon(Icons.history, size: 20),
//                       SizedBox(width: 8),
//                       Text('История'),
//                     ],
//                   ),
//                 ),
//                 const PopupMenuItem(
//                   value: 'settings',
//                   child: Row(
//                     children: [
//                       Icon(Icons.settings, size: 20),
//                       SizedBox(width: 8),
//                       Text('Настройки'),
//                     ],
//                   ),
//                 ),
//               ],
//             )
//           ],
//         ),
//         body: const Center(
//           child: Text('Перемещение'),
//         ),
//       );
// }
