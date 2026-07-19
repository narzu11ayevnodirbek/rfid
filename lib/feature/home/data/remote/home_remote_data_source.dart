import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:rfid/core/api/api_client.dart';
import 'package:rfid/core/constants/constants.dart';
import 'package:rfid/domain/failures/exceptions.dart';
import 'package:rfid/feature/home/data/dto/get_list_model/get_list_model.dart';
import 'package:rfid/feature/home/data/dto/inventory/inventory_dto.dart';
import 'package:rfid/feature/home/data/dto/inventory/products_dto.dart';
import 'package:rfid/feature/home/domain/use_case/get_list_use_case.dart';

class HomeRemoteDataSource {
  HomeRemoteDataSource({required Dio dio}) : _dio = dio;

  final Dio _dio;

  Future<List<GetListModel>> getList(GetListParams params) async {
    try {
      final response = await _dio.get<dynamic>(
        params.destination,
        queryParameters: params.queryParameters,
      );
      if (response.isSuccessful) {
        final List<GetListModel> list = [];
        for (final data in response.data) {
          list.add(switch (params.destination) {
            Urls.inventory => InventoryDto.fromJson(data),
            Urls.products => ProductsDto.fromJson(data),
            String() => GetListModel.fromJson(data),
          });
        }
        return list;
      }
      throw ServerException.fromResponse(response);
    } on DioException catch (e, stackTrace) {
      Logger()
        ..e(e, stackTrace: stackTrace)
        ..e(e.response);
      throw ServerException(
        message: e.message,
        statusCode: e.response?.statusCode,
        stackTrace: stackTrace,
        response: e.response?.data,
      );
    } catch (_) {
      rethrow;
    }
  }
}
