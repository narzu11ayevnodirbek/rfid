import 'dart:convert';

import 'package:rfid/core/network/json_reader.dart';
import 'package:rfid/core/storage/key_value_store.dart';
import 'package:rfid/features/inventory/data/models/inventory_plan_model.dart';
import 'package:rfid/features/inventory/domain/entities/inventory_draft.dart';

class InventoryLocalDataSource {
  const InventoryLocalDataSource(this._store);

  final KeyValueStore _store;

  static String _planKey(String inventoryId) => 'inventory_plan_$inventoryId';

  static String _draftKey(String inventoryId) => 'inventory_draft_$inventoryId';

  Future<void> savePlan(InventoryPlanModel plan) => _store.writeString(
        _planKey(plan.inventoryId),
        jsonEncode(plan.toJson()),
      );

  InventoryPlanModel? readPlan(String inventoryId) {
    final json = _decode(_store.readString(_planKey(inventoryId)));
    if (json == null) return null;
    return InventoryPlanModel.fromJson(json, inventoryId: inventoryId);
  }

  Future<void> saveDraft(String inventoryId, InventoryDraft draft) =>
      _store.writeString(
        _draftKey(inventoryId),
        jsonEncode({
          'scanned_items': draft.scannedEpcs,
          'saved_at': draft.savedAt.toIso8601String(),
        }),
      );

  InventoryDraft? readDraft(String inventoryId) {
    final json = _decode(_store.readString(_draftKey(inventoryId)));
    if (json == null) return null;
    final reader = JsonReader(json);
    return InventoryDraft(
      scannedEpcs: reader.stringList('scanned_items'),
      savedAt: DateTime.tryParse(reader.string('saved_at')) ?? DateTime.now(),
    );
  }

  Future<void> deleteDraft(String inventoryId) =>
      _store.delete(_draftKey(inventoryId));

  // A damaged entry is treated as missing.
  static JsonMap? _decode(String? source) {
    if (source == null) return null;
    try {
      return asJsonMap(jsonDecode(source));
    } on FormatException {
      return null;
    }
  }
}
