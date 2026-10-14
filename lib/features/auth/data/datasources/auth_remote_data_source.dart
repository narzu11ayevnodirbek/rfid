import 'package:rfid/core/network/api_client.dart';
import 'package:rfid/core/network/api_endpoints.dart';
import 'package:rfid/features/auth/data/models/login_response_model.dart';

/// Authentication requests.
class AuthRemoteDataSource {
  const AuthRemoteDataSource(this._api);

  final ApiClient _api;

  /// `POST api/auth.php?action=login` with `{login, password}`.
  Future<LoginResponseModel> login({
    required String login,
    required String password,
  }) async {
    final json = await _api.post(
      ApiEndpoints.auth,
      query: const {'action': 'login'},
      body: {'login': login, 'password': password},
    );
    return LoginResponseModel.fromJson(json);
  }
}
