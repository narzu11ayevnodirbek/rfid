import 'package:equatable/equatable.dart';

/// Tags scanned for an inventory that was not finished yet. Saved on the
/// device so a crash, a dead battery or a lost connection loses nothing.
class InventoryDraft extends Equatable {
  const InventoryDraft({required this.scannedEpcs, required this.savedAt});

  final List<String> scannedEpcs;
  final DateTime savedAt;

  @override
  List<Object?> get props => [scannedEpcs, savedAt];
}
