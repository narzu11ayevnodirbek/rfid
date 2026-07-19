import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../../../../../core/api/api_client.dart';
import '../../../../infrastructure/di/injector_container.dart';
import '../../../../core/api/api_client.dart';
import '../../../../infrastructure/di/injector_container.dart';
import '../models/marking_task_model.dart';

class MarkingItemsController extends GetxController {
  MarkingItemsController(this.markingId);

  final String markingId;

  RxList<MarkingTaskModel> items = <MarkingTaskModel>[].obs;
  RxBool isLoading = false.obs;

  final Dio _dio = sl<Dio>();

  @override
  void onInit() {
    fetchItems();
    super.onInit();
  }

  Future<void> fetchItems() async {
    isLoading.value = true;

    final res = await _dio.get(
      'api/get_marking_tasks_for_mobile.php',
      queryParameters: {'marking_id': int.tryParse(markingId) ?? markingId},
      options: optionsWithBearer(),
    );

    if (res.data['success'] == true) {
      items.value = (res.data['data'] as List)
          .map((e) => MarkingTaskModel.fromJson(e))
          .toList();
    }

    isLoading.value = false;
  }
}
