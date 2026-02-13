import 'package:dio/dio.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/base/local_source.dart';
import '../../../../injector_container.dart';
import '../models/marking_item.dart';
import '../models/marking_model.dart';

class MarkingService {
  MarkingService(this.localSource);

  final Dio _dio = sl<Dio>();
  final LocalSource localSource;

  Future<List<MarkingModel>> getMarkings() async {
    final response = await _dio.get(
      'api/markings.php',
      options: optionsWithBearer(),
    );

    if (response.data['success'] == true) {
      return (response.data['data'] as List)
          .map((e) => MarkingModel.fromJson(e))
          .toList();
    }

    return [];
  }

  Future<List<MarkingItem>> getMarkingItems(
      {required int markingId, required String taskId}) async {
    final response = await _dio.get('api/get_marking_items.php',
        queryParameters: {
          'marking_id': markingId,
        },
        options: optionsWithBearer());

    print('MARKING 🆔: $markingId');
    print(response.realUri);

    if (response.data is Map && response.data['success'] == true) {
      final List list = response.data['data'];

      return list
          .map((e) => MarkingItem.fromJson(e,
              markingId: markingId.toString(), taskId: taskId))
          .toList();
    }

    return [];
  }
}
