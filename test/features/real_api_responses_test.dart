import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:rfid/core/network/api_envelope_parser.dart';
import 'package:rfid/core/network/json_reader.dart';
import 'package:rfid/features/auth/data/models/login_response_model.dart';
import 'package:rfid/features/inventory/data/models/inventory_model.dart';
import 'package:rfid/features/inventory/data/models/inventory_plan_model.dart';
import 'package:rfid/features/inventory/data/models/inventory_task_model.dart';
import 'package:rfid/features/marking/data/models/marking_model.dart';
import 'package:rfid/features/movement/data/models/movement_task_model.dart';
import 'package:rfid/features/movement/data/models/storage_location_model.dart';

JsonMap _fixture(String name) => ApiEnvelopeParser.parse(
      jsonDecode(File('test/fixtures/api/$name.json').readAsStringSync()),
    );

List<JsonMap> _rows(String name) => JsonReader(_fixture(name)).mapList('data');

void main() {
  test('auth.php', () {
    final response = LoginResponseModel.fromJson(_fixture('auth_login'));

    expect(response.token, 'test-token');
    expect(response.user.id, '3');
  });

  test('inventory.php', () {
    final inventories = _rows('inventory').map(InventoryModel.fromJson);

    expect(inventories, hasLength(2));
    expect(inventories.every((inventory) => inventory.isClosed), isTrue);
    expect(inventories.first.responsibleName, '');
  });

  test('inventory_tasks.php', () {
    final task = InventoryTaskModel.fromJson(_rows('inventory_tasks').single);

    expect(task.inventoryId, '126');
    expect(task.status, 'pending');
    expect(task.employeeName, 'last_name 1 first_name 1');
    expect(task.totalCount, 0);
  });

  test('inventory_get_plan.php', () {
    final plan = InventoryPlanModel.fromJson(
      _fixture('inventory_plan'),
      inventoryId: '124',
    );

    expect(plan.inventoryId, '124');
    expect(plan.expectedItems, hasLength(1));
    expect(plan.expectedItems.single.epc, startsWith('E2806894'));
  });

  test('markings.php', () {
    expect(_rows('markings').map(MarkingModel.fromJson), isEmpty);
  });

  test('get_movement_tasks_for_mobile.php', () {
    final task = MovementTaskModel.fromJson(_rows('movement_tasks').single);

    expect(task.name, 'movement_name 1');
    expect(task.movementId, isNotEmpty);
    expect(task.totalCount, 0);
    expect(task.movedCount, 0);
  });

  test('locations.php', () {
    final locations = _rows('locations').map(StorageLocationModel.fromJson);

    expect(locations, hasLength(3));
    expect(
      locations.every((location) => location.displayName.isNotEmpty),
      isTrue,
    );
  });

  test('401 body carries the reason under error', () {
    final body = File('test/fixtures/api/unauthorized.json').readAsStringSync();

    expect(ApiEnvelopeParser.messageOf(body), isNotNull);
  });
}
