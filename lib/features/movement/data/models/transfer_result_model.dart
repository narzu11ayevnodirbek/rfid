import 'package:rfid/core/network/json_reader.dart';
import 'package:rfid/features/movement/domain/entities/transfer_result.dart';

/// [TransferResult] from `api/process_movement_batch.php` and
/// `api/transfer_free.php`:
///
/// ```json
/// { "success": true, "message": "...", "moved_count": 3,
///   "errors": { "unknown_epcs": ["E2..."], "not_in_source": [...],
///               "already_here": [{"name": "..."}], "blocked": [...] } }
/// ```
///
/// Problem lists contain either plain values or objects; both become text.
class TransferResultModel extends TransferResult {
  const TransferResultModel({
    required super.movedCount,
    super.message,
    super.unknownEpcs,
    super.notInSource,
    super.alreadyHere,
    super.blocked,
  });

  factory TransferResultModel.fromJson(JsonMap json) {
    final reader = JsonReader(json);
    final errors = JsonReader(reader.mapOrNull('errors') ?? const {});
    const labelKeys = ['name', 'epc', 'item_id', 'status'];
    return TransferResultModel(
      movedCount: reader.integer('moved_count'),
      message: reader.stringOrNull('message'),
      unknownEpcs: errors.stringList('unknown_epcs'),
      notInSource: errors.labelList('not_in_source', labelKeys: labelKeys),
      alreadyHere: errors.labelList('already_here', labelKeys: labelKeys),
      blocked: errors.labelList('blocked', labelKeys: labelKeys),
    );
  }
}
