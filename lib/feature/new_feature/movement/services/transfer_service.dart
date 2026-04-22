import 'package:dio/dio.dart';
import '../../../../../core/api/api_client.dart';
import '../../../../../injector_container.dart';
import '../../../../core/api/api_client.dart';
import '../../../../injector_container.dart';
import '../models/location_model.dart';

/// ТЗ: API перемещений — локации, свободное перемещение, обновление статуса целевого.
class TransferService {
  final Dio _dio = sl<Dio>();

  /// GET /api/locations — список локаций для выбора "куда перемещаем".
  Future<List<LocationModel>> getLocations() async {
    final response = await _dio.get(
      'api/locations.php',
      options: optionsWithBearer(),
    );
    if (response.data is Map && response.data['success'] == true) {
      return (response.data['data'] as List)
          .map((e) => LocationModel.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
    }
    return [];
  }

  /// POST /api/transfer/free — свободное перемещение.
  /// Возвращает: success, moved_count, errors: { unknown_epcs, already_here, blocked }.
  Future<FreeTransferResult> freeTransfer({
    required int newLocationId,
    required List<String> scannedEpcs,
    int userId = 0,
    String? timestamp,
  }) async {
    try {

      final payload = {
        'new_location_id': newLocationId,
        'scanned_epcs': scannedEpcs,
        'user_id': userId,
        'timestamp': timestamp ?? _mysqlNowUtc(),
      };

      print('FREE TRANSFER PAYLOAD => $payload');
      final response = await _dio.post(
        'api/transfer_free.php',
        data: {
          'new_location_id': newLocationId,
          'scanned_epcs': scannedEpcs,
          'user_id': userId,
          'timestamp': timestamp ?? _mysqlNowUtc(),
        },
        options: optionsWithBearer(),
      );

      print('FREE TRANSFER RESPONSE => ${response.data}');
      final d = response.data as Map<String, dynamic>;
      return FreeTransferResult(
        success: d['success'] == true,
        message: d['message']?.toString(),
        movedCount: int.tryParse(d['moved_count']?.toString() ?? '0') ?? 0,
        unknownEpcs: List<String>.from(d['errors']?['unknown_epcs'] ?? []),
        alreadyHere: _mapErrorList(d['errors']?['already_here'], 'name'),
        blocked: _mapErrorList(d['errors']?['blocked'], 'name'),
      );
    } on DioException catch (e) {
      final data = e.response?.data;
      String msg = 'Ошибка сети';
      if (data is Map && data['error'] != null) msg = data['error'].toString();
      if (data is Map && data['message'] != null) msg = data['message'].toString();
      return FreeTransferResult(success: false, message: msg);
    }
  }

  /// POST /api/process_movement_batch.php — отправка списка EPC по перемещению (сборка по факту).
  Future<MovementBatchResult> movementBatch({
    required int movementId,
    required List<String> scannedEpcs,
  }) async {
    try {
      final response = await _dio.post(
        'api/process_movement_batch.php',
        data: {'movement_id': movementId, 'scanned_epcs': scannedEpcs},
        options: optionsWithBearer(),
      );
      final d = response.data as Map<String, dynamic>;
      return MovementBatchResult(
        success: d['success'] == true,
        message: d['message']?.toString(),
        movedCount: int.tryParse(d['moved_count']?.toString() ?? '0') ?? 0,
        unknownEpcs: List<String>.from(d['errors']?['unknown_epcs'] ?? []),
        notInSource: (d['errors']?['not_in_source'] as List?)?.map((e) => e is Map ? (e['name'] ?? e['epc'] ?? '').toString() : e.toString()).toList() ?? [],
      );
    } on DioException catch (e) {
      final data = e.response?.data;
      String msg = 'Ошибка сети';
      if (data is Map && data['message'] != null) msg = data['message'].toString();
      if (data is Map && data['error'] != null) msg = data['error'].toString();
      return MovementBatchResult(success: false, message: msg);
    }
  }

  /// POST /api/transfer/mission/update — обновление статуса целевого перемещения.
  Future<bool> missionUpdate({required int movementId, required String status}) async {
    try {
      final response = await _dio.post(
        'api/transfer_mission_update.php',
        data: {'id': movementId, 'status': status},
        options: optionsWithBearer(),
      );
      return response.data is Map && response.data['success'] == true;
    } on DioException catch (_) {
      return false;
    }
  }

  String _mysqlNowUtc() {
    final d = DateTime.now().toUtc();
    String two(int n) => n.toString().padLeft(2, '0');
    return '${d.year}-${two(d.month)}-${two(d.day)} ${two(d.hour)}:${two(d.minute)}:${two(d.second)}';
  }
}

List<String> _mapErrorList(dynamic list, String key) {
  if (list is! List) return [];
  return list.map((e) => e is Map ? (e[key] ?? e['item_id'] ?? e['status'] ?? '').toString() : e.toString()).toList();
}

class FreeTransferResult {
  FreeTransferResult({
    required this.success,
    this.message,
    this.movedCount = 0,
    this.unknownEpcs = const [],
    this.alreadyHere = const [],
    this.blocked = const [],
  });

  final bool success;
  final String? message;
  final int movedCount;
  final List<String> unknownEpcs;
  final List<String> alreadyHere;
  final List<String> blocked;
}

class MovementBatchResult {
  MovementBatchResult({
    required this.success,
    this.message,
    this.movedCount = 0,
    this.unknownEpcs = const [],
    this.notInSource = const [],
  });

  final bool success;
  final String? message;
  final int movedCount;
  final List<String> unknownEpcs;
  final List<String> notInSource;
}
