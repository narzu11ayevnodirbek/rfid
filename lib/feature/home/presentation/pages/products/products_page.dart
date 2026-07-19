import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:rfid/infrastructure/enums/status_enums.dart';
import 'package:rfid/core/extension/extension.dart';
import 'package:rfid/presentation/components/custom_app_bar.dart';
import 'package:rfid/presentation/components/loading_view.dart';
import 'package:rfid/feature/home/presentation/bloc/products/products_bloc.dart';
import 'package:rfid/feature/home/presentation/pages/products/widget/products_item.dart';

part 'mixin/products_mixin.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> with ProductsMixin {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: const CustomAppBar(title: 'Продукты'),
        body: BlocBuilder<ProductsBloc, ProductsState>(
          buildWhen: (oldState, newState) {
            if (oldState.status.isLoading && newState.status.isError) {
              EasyLoading.showError(newState.message);
            }
            return true;
          },
          builder: (context, state) => Stack(
            children: [
              CustomScrollView(
                controller: _scrollController,
                slivers: [
                  12.kSliverGap,
                  if (state.productsList.isNotEmpty)
                    SliverPadding(
                      padding: 16.kPaddingHorizontal,
                      sliver: SliverList.separated(
                        itemCount: state.productsList.length,
                        itemBuilder: (context, index) {
                          final item = state.productsList[index];
                          return ProductsItem(item: item);
                        },
                        separatorBuilder: (_, __) => 12.kBoxHeight,
                      ),
                    ),
                  if (state.productsList.isEmpty && !state.status.isLoading)
                    const SliverFillRemaining(child: Text('List is empty')),
                  12.kSliverGap,
                ],
              ),
              if (state.status.isLoading) const LoadingView(withOpacityBackground: true),
            ],
          ),
        ),
      );
}
