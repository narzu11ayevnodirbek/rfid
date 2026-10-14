import 'package:rfid/core/network/api_client.dart';
import 'package:rfid/core/network/api_endpoints.dart';
import 'package:rfid/core/network/json_reader.dart';
import 'package:rfid/features/movement/data/models/movement_task_model.dart';
import 'package:rfid/features/movement/data/models/storage_location_model.dart';
import 'package:rfid/features/movement/data/models/transfer_result_model.dart';

/// Movement requests. See `docs/API.md` for the exact shapes.
class MovementRemoteDataSource {
  const MovementRemoteDataSource(this._api);

  final ApiClient _api;

  /// `GET api/get_movement_tasks_for_mobile.php`
  Future<List<MovementTaskModel>> getTasks() async {
    final json = await _api.get(ApiEndpoints.movementTasks);
    return JsonReader(json)
        .mapList('data')
        .map(MovementTaskModel.fromJson)
        .toList();
  }

  /// `POST api/process_movement_batch.php`
  Future<TransferResultModel> moveForTask({
    required String movementId,
    required List<String> scannedEpcs,
  }) async {
    final json = await _api.post(
      ApiEndpoints.movementBatch,
      body: {
        'movement_id': int.tryParse(movementId) ?? movementId,
        'scanned_epcs': scannedEpcs,
      },
    );
    return TransferResultModel.fromJson(json);
  }

  /// `GET api/locations.php`
  Future<List<StorageLocationModel>> getLocations() async {
    final json = await _api.get(ApiEndpoints.locations);
    return JsonReader(json)
        .mapList('data')
        .map(StorageLocationModel.fromJson)
        .toList();
  }

  /// `POST api/transfer_free.php`
  Future<TransferResultModel> moveFreely({
    required String locationId,
    required List<String> scannedEpcs,
    required String userId,
    required DateTime timestamp,
  }) async {
    final json = await _api.post(
      ApiEndpoints.freeTransfer,
      body: {
        'new_location_id': int.tryParse(locationId) ?? locationId,
        'scanned_epcs': scannedEpcs,
        'user_id': int.tryParse(userId) ?? 0,
        'timestamp': _mysqlUtc(timestamp),
      },
    );
    return TransferResultModel.fromJson(json);
  }

  /// `2025-10-06 09:30:00` in UTC, the format the backend stores.
  static String _mysqlUtc(DateTime time) {
    final utc = time.toUtc();
    String two(int value) => value.toString().padLeft(2, '0');
    return '${utc.year}-${two(utc.month)}-${two(utc.day)} '
        '${two(utc.hour)}:${two(utc.minute)}:${two(utc.second)}';
  }
}
