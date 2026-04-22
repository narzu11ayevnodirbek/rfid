import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:rf_id_test/core/api/interceptors/http_to_https_interceptor.dart';
// import 'package:rf_id_test/feature/new_feature/movement/models/movement_model.dart';
import '../models/movement_item.dart';
import '../models/movement_model.dart';

class MovementService {
  MovementService() {
    dio = Dio();

    dio.interceptors.add(HttpToHttpsInterceptor());

    (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
      final client = HttpClient()
        ..badCertificateCallback = (cert, host, port) {
          if (host == 'mderp.uz') {
            print('⚠️ Allowing bad certificate for $host');
            return true;
          }
          return false;
        };
      return client;
    };
  }

  late final Dio dio;

  Future<List<MovementModel>> getMovements() async {
    try {
      final response = await dio.get('https://mderp.uz/api/movements.php');
      if (response.data['success'] == true) {
        return (response.data['data'] as List)
            .map((e) => MovementModel.fromJson(e))
            .toList();
      }
      return [];
    } on DioException catch (e) {
      debugPrint('DioException getMovements: $e');
      rethrow;
    } catch (e) {
      debugPrint('Unknown error getMovements: $e');
      rethrow;
    }
  }

  Future<bool> createMovement({
    required String name,
    required String destination,
    required String description,
  }) async {
    print('✅ createMovement() chaqirildi');
    print('📤 Yuborilayotgan body:');
    print(
      {
        'name': name,
        'destination': destination,
        'description': description,
      },
    );

    try {
      final response = await dio.post(
        'https://mderp.uz/api/movements.php',
        data: {
          'name': name,
          'destination': destination,
          'description': description,
        },
      );

      print('✅ Status code: ${response.statusCode}');
      print('✅ Body: ${response.data}');

      return response.statusCode == 200;
    } catch (e) {
      print('❌ Yuborishda xatolik: $e');
      return false;
    }
  }

  Future<List<MovementItem>> getMovementItems({
    required int movementId,
  }) async {
    final response = await dio.get(
      'https://mderp.uz/api/get_movement_items.php',
      queryParameters: {
        'movement_id': movementId,
      },
    );

    print('Movement IDDDDD: $movementId');

    if (response.data is Map && response.data['success'] == true) {
      final List list = response.data['data'];

      return list
          .map((e) =>
              MovementItem.fromJson(e, movementId: movementId.toString()))
          .toList();
    }

    return [];
  }

  Future<String> getItemPhoto({
    required int movementId,
    required String itemId,
  }) async {
    final response = await dio.get(
      'https://mderp.uz/api/get_movement_items.php',
      queryParameters: {'movement_id': movementId},
    );

    if (response.data is Map && response.data['success'] == true) {
      final List list = response.data['data'] ?? [];
      final found = list.cast<Map>().firstWhere(
            (e) => (e['item_id'] ?? e['id']).toString() == itemId,
        orElse: () => {},
      );

      // photo yoki photo_path bo‘lsa olamiz
      final p = (found['photo'] ?? found['photo_path'] ?? '').toString();
      return p;
    }
    return '';
  }
}
