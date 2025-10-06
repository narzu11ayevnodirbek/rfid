import 'package:dio/dio.dart';
import 'package:rf_id_test/core/api/api_client.dart';
import 'package:rf_id_test/core/constants/constants.dart';
import 'package:rf_id_test/core/error/exceptions.dart';
import 'package:rf_id_test/feature/auth/data/dto/user_dto.dart';
import 'package:rf_id_test/feature/auth/domain/repository/auth_params.dart';

class AuthRemoteDataSource {
  AuthRemoteDataSource({required Dio dio}) : _dio = dio;

  final Dio _dio;

  Future<AuthResponse> authenticate(AuthParams params) async {
    try {
      final response = await _dio.post<dynamic>(
        Urls.auth,
        queryParameters: {'action': params.action},
        data: params.toJson(),
      );
      if (response.isSuccessful) {
        return AuthResponse.fromJson(response.data);
      }
      throw ServerException.fromResponse(response);
    } on DioException catch (e, stackTrace) {
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
