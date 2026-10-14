import 'package:rfid/core/network/api_client.dart';
import 'package:rfid/core/network/api_endpoints.dart';
import 'package:rfid/core/network/json_reader.dart';
import 'package:rfid/features/marking/data/models/marking_model.dart';
import 'package:rfid/features/marking/data/models/marking_task_model.dart';

class MarkingRemoteDataSource {
  const MarkingRemoteDataSource(this._api);

  final ApiClient _api;

  Future<List<MarkingModel>> getMarkings() async {
    final json = await _api.get(ApiEndpoints.markings);
    return JsonReader(json).mapList('data').map(MarkingModel.fromJson).toList();
  }

  Future<List<MarkingTaskModel>> getTasks(String markingId) async {
    final json = await _api.get(
      ApiEndpoints.markingTasks,
      query: {'marking_id': markingId},
    );
    return JsonReader(json)
        .mapList('data')
        .map(MarkingTaskModel.fromJson)
        .toList();
  }

  Future<String> getItemPhotoPath({
    required String markingId,
    required String itemId,
  }) async {
    final json = await _api.get(
      ApiEndpoints.markingItems,
      query: {'marking_id': markingId},
    );
    for (final item in JsonReader(json).mapList('data')) {
      final reader = JsonReader(item);
      if (reader.firstString(const ['id', 'item_id']) == itemId) {
        return reader.firstString(const ['photo', 'photo_path']);
      }
    }
    return '';
  }

  Future<void> bindTag({
    required String markingId,
    required String taskId,
    required String itemId,
    required String epc,
  }) async {
    await _api.post(
      ApiEndpoints.markingBindTag,
      body: {
        'marking_id': markingId,
        'task_id': taskId,
        'item_id': itemId,
        'rfid': epc,
      },
    );
  }
}
