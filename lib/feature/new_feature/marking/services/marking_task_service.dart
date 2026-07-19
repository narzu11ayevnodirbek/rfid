import 'package:dio/dio.dart';
import '../../../../../core/api/api_client.dart';
import '../../../../../core/base/local_source.dart';
import '../../../../infrastructure/di/injector_container.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/base/local_source.dart';
import '../../../../infrastructure/di/injector_container.dart';
import '../models/marking_model.dart';

class MarkingTaskService {
  MarkingTaskService(this.localSource);

  final Dio _dio = sl<Dio>();
  final LocalSource localSource;

  Future<List<MarkingModel>> getMarkingTasks() async {
    final response = await _dio.get(
      'api/get_marking_tasks_for_mobile.php',
      options: optionsWithBearer(),
    );

    if (response.data['success'] == true) {
      return (response.data['data'] as List)
          .map((e) => MarkingModel.fromJson(e))
          .toList();
    }

    return [];
  }
}
