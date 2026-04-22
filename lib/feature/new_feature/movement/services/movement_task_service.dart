import 'package:dio/dio.dart';

import '../../../../../core/api/api_client.dart';
import '../../../../../injector_container.dart';
import '../../../../core/api/api_client.dart';
import '../../../../injector_container.dart';
import '../models/movement_task_model.dart';

class MovementTaskService {
  final Dio _dio = sl<Dio>();

  Future<List<MovementTaskModel>> getTasks() async {
    final res = await _dio.get(
      'api/get_movement_tasks_for_mobile.php',
      options: optionsWithBearer(),
    );

    if (res.data['success'] == true) {
      return (res.data['data'] as List)
          .map((e) => MovementTaskModel.fromJson(e))
          .toList();
    }
    return [];
  }
}
