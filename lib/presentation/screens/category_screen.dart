import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';

import '../../app/di.dart';
import '../blocs/category/category_cubit.dart';
import '../blocs/user/user_bloc.dart';
import '../widgets/category/empty_category.dart';
import '../widgets/error_widget.dart';
import '../widgets/home/products_grid_item.dart';
import '../widgets/loading_widget.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen(this.cateName, {Key? key}) : super(key: key);

  final String cateName;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CategoryCubit>(
      create: (_) => sl<CategoryCubit>()..getProducts(cateName),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Ionicons.chevron_back),
          ),
          title: Text(cateName),
        ),
        body: BlocBuilder<CategoryCubit, CategoryState>(
          buildWhen: (previous, current) {
            return previous.pageStatus != current.pageStatus ||
                previous.products != current.products;
          },
          builder: (context, state) {
            if (state.pageStatus == PageStatus.loading) {
              return const LoadingWidget();
            } else if (state.pageStatus == PageStatus.error) {
              return FailureWidget(error: state.errorMessage!);
            } else {
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<CategoryCubit>().getProducts(cateName);
                },
                child: ConditionalBuilder(
                  condition: state.products.isNotEmpty,
                  builder: (context) {
                    return GridView.builder(
                      padding: const EdgeInsets.all(12.0),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisExtent: 380.0,
                        mainAxisSpacing: 1.0,
                        crossAxisSpacing: 12.0,
                      ),
                      primary: false,
                      shrinkWrap: true,
                      itemCount: state.products.length,
                      itemBuilder: (_, index) {
                        final product = state.products[index];
                        return BlocProvider<UserBloc>.value(
                          value: context.read<UserBloc>(),
                          child: ProductsGridItem(product, index),
                        );
                      },
                    );
                  },
                  fallback: (context) {
                    return const EmptyCategory();
                  },
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
