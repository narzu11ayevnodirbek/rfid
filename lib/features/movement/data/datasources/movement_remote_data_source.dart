import 'package:rfid/core/network/api_client.dart';
import 'package:rfid/core/network/api_endpoints.dart';
import 'package:rfid/core/network/json_reader.dart';
import 'package:rfid/features/movement/data/models/movement_task_model.dart';
import 'package:rfid/features/movement/data/models/storage_location_model.dart';
import 'package:rfid/features/movement/data/models/transfer_result_model.dart';

class MovementRemoteDataSource {
  const MovementRemoteDataSource(this._api);

  final ApiClient _api;

  Future<List<MovementTaskModel>> getTasks() async {
    final json = await _api.get(ApiEndpoints.movementTasks);
    return JsonReader(json)
        .mapList('data')
        .map(MovementTaskModel.fromJson)
        .toList();
  }

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

  Future<List<StorageLocationModel>> getLocations() async {
    final json = await _api.get(ApiEndpoints.locations);
    return JsonReader(json)
        .mapList('data')
        .map(StorageLocationModel.fromJson)
        .toList();
  }

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

  // The backend stores UTC as `yyyy-MM-dd HH:mm:ss`.
  static String _mysqlUtc(DateTime time) {
    final utc = time.toUtc();
    String two(int value) => value.toString().padLeft(2, '0');
    return '${utc.year}-${two(utc.month)}-${two(utc.day)} '
        '${two(utc.hour)}:${two(utc.minute)}:${two(utc.second)}';
  }
}
