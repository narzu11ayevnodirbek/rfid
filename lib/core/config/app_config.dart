/// Values come from `.env` (`flutter run --dart-define-from-file=.env`);
/// see `.env.example`.
abstract final class AppConfig {
  static const String apiBaseUrl = String.fromEnvironment('API_BASE_URL');

  static const bool trustApiHostCertificate =
      bool.fromEnvironment('TRUST_API_HOST_CERTIFICATE');

  static const bool useFakeRfidReader = bool.fromEnvironment('FAKE_RFID');

  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 45);

  static bool get isConfigured => apiBaseUrl.isNotEmpty;

  static String get apiHost => Uri.parse(apiBaseUrl).host;

  static String resolveFileUrl(String path) {
    if (path.startsWith('http://') || path.startsWith('https://')) return path;
    return Uri.parse(apiBaseUrl).resolve(path).toString();
  }
}
