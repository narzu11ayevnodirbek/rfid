part of 'package:rf_id_test/feature/home/presentation/pages/inventory/inventory_page.dart';

mixin InventoryMixin on State<InventoryPage> {
  late final InventoryBloc _bloc;

  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _bloc = context.read<InventoryBloc>();
    _bloc.add(InitialInventoryEvent());

    _scrollController = ScrollController();
  }

  Future<void> _onRefresh() async => Future.delayed(
        const Duration(seconds: 1),
        () => _bloc.add(InitialInventoryEvent()),
      );
}
