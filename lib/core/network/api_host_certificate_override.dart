import 'dart:io';

/// Accepts an unverifiable TLS certificate for one host only.
///
/// Installed in `bootstrap()` when `AppConfig.trustApiHostCertificate` is on.
/// It covers both API calls and photos loaded with `Image.network`, because
/// both create their HTTP client through [HttpOverrides].
///
/// This weakens transport security for that host: anyone on the network path
/// can read or change the traffic. It exists because the legacy app could not
/// verify the server certificate. Remove it once the server has a certificate
/// the device trusts.
class ApiHostCertificateOverride extends HttpOverrides {
  ApiHostCertificateOverride(this.trustedHost);

  final String trustedHost;

  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (_, host, __) => host == trustedHost;
  }
}
