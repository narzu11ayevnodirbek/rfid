part of 'inventory_scan_bloc.dart';

/// Which part of the result the list shows.
enum ReconciliationList { missing, found, extra }

class InventoryScanState extends Equatable {
  const InventoryScanState({
    required this.inventoryId,
    this.inventoryName,
    this.isLoadingPlan = false,
    this.plan,
    this.isPlanFromCache = false,
    this.planFailure,
    this.scan = const TagScanState(),
    this.reconciliation = const InventoryReconciliation(),
    this.selectedList = ReconciliationList.missing,
    this.restoredDraftCount = 0,
    this.submitStatus = SubmitStatus.idle,
    this.submitFailure,
  });

  final String inventoryId;

  /// `null` until the inventory list was loaded once.
  final String? inventoryName;
  final bool isLoadingPlan;

  /// `null` while loading or when it could not be loaded at all; scanning
  /// still works then and every tag counts as extra.
  final InventoryPlan? plan;
  final bool isPlanFromCache;
  final Failure? planFailure;
  final TagScanState scan;
  final InventoryReconciliation reconciliation;
  final ReconciliationList selectedList;

  /// Tags put back from a draft when the screen opened.
  final int restoredDraftCount;
  final SubmitStatus submitStatus;
  final Failure? submitFailure;

  String get title => inventoryName ?? inventoryId;

  bool get isPlanEmpty =>
      plan != null && plan!.expectedItems.isEmpty && !isLoadingPlan;

  InventoryScanState copyWith({
    String? inventoryName,
    bool? isLoadingPlan,
    InventoryPlan? plan,
    bool? isPlanFromCache,
    Failure? planFailure,
    bool clearPlanFailure = false,
    TagScanState? scan,
    InventoryReconciliation? reconciliation,
    ReconciliationList? selectedList,
    int? restoredDraftCount,
    SubmitStatus? submitStatus,
    Failure? submitFailure,
  }) {
    return InventoryScanState(
      inventoryId: inventoryId,
      inventoryName: inventoryName ?? this.inventoryName,
      isLoadingPlan: isLoadingPlan ?? this.isLoadingPlan,
      plan: plan ?? this.plan,
      isPlanFromCache: isPlanFromCache ?? this.isPlanFromCache,
      planFailure: clearPlanFailure ? null : planFailure ?? this.planFailure,
      scan: scan ?? this.scan,
      reconciliation: reconciliation ?? this.reconciliation,
      selectedList: selectedList ?? this.selectedList,
      restoredDraftCount: restoredDraftCount ?? this.restoredDraftCount,
      submitStatus: submitStatus ?? this.submitStatus,
      submitFailure: submitStatus == SubmitStatus.failed
          ? submitFailure ?? this.submitFailure
          : null,
    );
  }

  @override
  List<Object?> get props => [
        inventoryId,
        inventoryName,
        isLoadingPlan,
        plan,
        isPlanFromCache,
        planFailure,
        scan,
        reconciliation,
        selectedList,
        restoredDraftCount,
        submitStatus,
        submitFailure,
      ];
}
