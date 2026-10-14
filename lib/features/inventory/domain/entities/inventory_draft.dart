import 'package:equatable/equatable.dart';

class InventoryDraft extends Equatable {
  const InventoryDraft({required this.scannedEpcs, required this.savedAt});

  final List<String> scannedEpcs;
  final DateTime savedAt;

  @override
  List<Object?> get props => [scannedEpcs, savedAt];
}
