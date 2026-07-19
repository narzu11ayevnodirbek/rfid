import 'package:dio/dio.dart';
import 'package:rfid/infrastructure/di/injector_container.dart';
import 'package:rfid/feature/new_feature/inventory/models/tag_model.dart';

class ItemsService {
  final Dio _dio = sl<Dio>();

  Future<List<TagModel>> fetchItems() async {
    try {
      final response = await _dio.get('api/items.php');

      if (response.data['success'] == true) {
        final List list = response.data['data'];

        return list.map((e) => TagModel.fromJson(e)).toList();
      }

      return [];
    } on DioException catch (e) {
      print('DioException fetchItems: ${e.response?.data}');
      rethrow;
    }
  }
}
