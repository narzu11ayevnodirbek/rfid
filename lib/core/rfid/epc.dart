/// Helpers for EPC codes, the identifiers stored on UHF tags.
abstract final class Epc {
  /// The one canonical form of an EPC used everywhere in the app: no spaces
  /// around it, upper-case hex.
  ///
  /// Every tag passes through here when it enters the app (the reader) and
  /// every EPC from the server is compared in this form, so "e200 " and
  /// "E200" are always the same tag.
  static String normalize(String raw) => raw.trim().toUpperCase();
}
