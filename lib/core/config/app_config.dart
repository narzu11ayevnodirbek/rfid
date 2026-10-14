/// Compile-time configuration.
///
/// Every value can be overridden when building or running the app:
///
/// ```sh
/// flutter run --dart-define=API_BASE_URL=https://example.uz/ --dart-define=FAKE_RFID=true
/// ```
abstract final class AppConfig {
  /// Root of the backend. Must end with a slash, endpoints are relative to it.
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://mderp.uz/',
  );

  /// Accept the certificate of the API host even when it cannot be verified.
  ///
  /// The legacy app accepted *any* certificate for *any* host. This flag keeps
  /// the exception but limits it to [apiHost]. Turn it off as soon as the
  /// server has a certificate the device trusts.
  static const bool trustApiHostCertificate = bool.fromEnvironment(
    'TRUST_API_HOST_CERTIFICATE',
    defaultValue: true,
  );

  /// Replace the hardware reader with a simulated one (emulators, desktop).
  static const bool useFakeRfidReader = bool.fromEnvironment('FAKE_RFID');

  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 45);

  static String get apiHost => Uri.parse(apiBaseUrl).host;

  /// Turns a file path returned by the API (for example a photo) into a URL.
  ///
  /// The backend returns either absolute URLs or paths relative to the root.
  static String resolveFileUrl(String path) {
    if (path.startsWith('http://') || path.startsWith('https://')) return path;
    return Uri.parse(apiBaseUrl).resolve(path).toString();
  }
}
