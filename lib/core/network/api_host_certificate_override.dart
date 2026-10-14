import 'dart:io';

/// Accepts an unverifiable TLS certificate for the API host only. Anyone on
/// the network path can then read or change that traffic: switch it off
/// (TRUST_API_HOST_CERTIFICATE=false) once the server certificate is trusted.
class ApiHostCertificateOverride extends HttpOverrides {
  ApiHostCertificateOverride(this.trustedHost);

  final String trustedHost;

  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (_, host, __) => host == trustedHost;
  }
}
