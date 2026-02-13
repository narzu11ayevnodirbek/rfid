// import 'package:dio/dio.dart';
//
// class RfidApi {
//   final dio = Dio(BaseOptions(
//     baseUrl: 'https://mderp.uz/api/',
//     contentType: 'application/json',
//   ));
//
//   Future<bool> saveTag(String epc) async {
//     try {
//       final res = await dio.post(
//         'rfid.php',
//         data: {
//           'epc': epc,
//           'action': 'save',
//         },
//       );
//
//       print('RFID API RESULT: ${res.data}');
//       return res.data['success'] == true;
//     } catch (e) {
//       print('RFID API ERROR: $e');
//       return false;
//     }
//   }
//
//   Future<Map?> getTag(String epc) async {
//     try {
//       final res = await dio.get(
//         'rfid.php',
//         queryParameters: {'epc': epc},
//       );
//       return res.data;
//     } catch (e) {
//       print('RFID GET ERROR: $e');
//       return null;
//     }
//   }
// }
