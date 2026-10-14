import 'dart:async';

import 'package:flutter/foundation.dart';

/// Turns a stream (for example a bloc's) into the `Listenable` that
/// `GoRouter.refreshListenable` expects, so redirects are re-evaluated on
/// every new value.
class StreamListenable extends ChangeNotifier {
  StreamListenable(Stream<Object?> stream) {
    _subscription = stream.listen((_) => notifyListeners());
  }

  late final StreamSubscription<Object?> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
