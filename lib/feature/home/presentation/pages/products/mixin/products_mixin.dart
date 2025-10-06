part of 'package:rf_id_test/feature/home/presentation/pages/products/products_page.dart';

mixin ProductsMixin on State<ProductsPage> {
  late final ProductsBloc _bloc;
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _bloc = context.read<ProductsBloc>();
    _bloc.add(InitialProductsEvent());

    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if ((_scrollController.offset == _scrollController.position.maxScrollExtent) &&
          !_bloc.addListLoading) {
        _bloc.add(AddListProductsEvent());
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
