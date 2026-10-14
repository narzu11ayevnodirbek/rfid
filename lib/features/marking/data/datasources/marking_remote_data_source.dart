import 'package:rfid/core/network/api_client.dart';
import 'package:rfid/core/network/api_endpoints.dart';
import 'package:rfid/core/network/json_reader.dart';
import 'package:rfid/features/marking/data/models/marking_model.dart';
import 'package:rfid/features/marking/data/models/marking_task_model.dart';

/// Marking requests. See `docs/API.md` for the exact shapes.
class MarkingRemoteDataSource {
  const MarkingRemoteDataSource(this._api);

  final ApiClient _api;

  /// `GET api/markings.php`
  Future<List<MarkingModel>> getMarkings() async {
    final json = await _api.get(ApiEndpoints.markings);
    return JsonReader(json).mapList('data').map(MarkingModel.fromJson).toList();
  }

  /// `GET api/get_marking_tasks_for_mobile.php?marking_id=` — tasks with
  /// their items embedded.
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

  /// `GET api/get_marking_items.php?marking_id=` — the only endpoint that
  /// returns photos, so the item is looked up in the whole marking.
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

  /// `POST api/process_marking_scan.php`
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
