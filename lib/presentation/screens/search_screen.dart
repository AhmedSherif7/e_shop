import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';

import '../../app/di.dart';
import '../blocs/search/search_cubit.dart';
import '../blocs/theme/theme_cubit.dart';
import '../blocs/user/user_bloc.dart';
import '../resources/colors_manager.dart';
import '../resources/font_manager.dart';
import '../widgets/error_widget.dart';
import '../widgets/loading_widget.dart';
import '../widgets/search/empty_search.dart';
import '../widgets/search/searchFiltersWidget.dart';
import 'product_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SearchCubit>(
      create: (_) => sl<SearchCubit>(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Search'),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Ionicons.chevron_back),
          ),
          actions: const [
            SearchFiltersWidget(),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Builder(
                  builder: (context) {
                    return BlocListener<SearchCubit, SearchState>(
                      listenWhen: (previous, current) {
                        return previous.searchPageStatus !=
                            current.searchPageStatus;
                      },
                      listener: (context, state) {
                        if (state.searchPageStatus == SearchPageStatus.clear) {
                          searchController.clear();
                        }
                      },
                      child: BlocBuilder<ThemeCubit, ThemeState>(
                        builder: (context, state) {
                          return TextField(
                            style: TextStyle(
                              color: state.isDarkMode
                                  ? ColorManager.white
                                  : ColorManager.black,
                            ),
                            controller: searchController,
                            onChanged: (value) {
                              context.read<SearchCubit>().searchChanged(value);
                            },
                            decoration: InputDecoration(
                              hintText: 'What are you looking for ?',
                              prefixIcon: BlocBuilder<SearchCubit, SearchState>(
                                buildWhen: (previous, current) {
                                  return previous.products != current.products;
                                },
                                builder: (context, state) {
                                  return IconButton(
                                    icon: Icon(
                                      Ionicons.close_outline,
                                      color: state.products.isEmpty
                                          ? ColorManager.grey
                                          : ColorManager.indigo,
                                    ),
                                    onPressed: state.products.isEmpty
                                        ? null
                                        : () {
                                            FocusScope.of(context).unfocus();
                                            context
                                                .read<SearchCubit>()
                                                .clearResults();
                                          },
                                  );
                                },
                              ),
                              suffixIcon: BlocBuilder<SearchCubit, SearchState>(
                                buildWhen: (previous, current) {
                                  return previous.search != current.search;
                                },
                                builder: (context, state) {
                                  return IconButton(
                                    icon: Icon(
                                      Ionicons.search,
                                      color: state.search.isEmpty
                                          ? ColorManager.grey
                                          : ColorManager.indigo,
                                    ),
                                    onPressed: state.search.isEmpty
                                        ? null
                                        : () {
                                            // searchController.clear();
                                            FocusScope.of(context).unfocus();
                                            context
                                                .read<SearchCubit>()
                                                .search();
                                          },
                                  );
                                },
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                borderSide: BorderSide(
                                  color: state.isDarkMode
                                      ? ColorManager.white
                                      : ColorManager.black,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: ColorManager.indigo,
                                ),
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                borderSide: BorderSide(
                                  color: state.isDarkMode
                                      ? ColorManager.white
                                      : ColorManager.black,
                                ),
                              ),
                              contentPadding: const EdgeInsets.all(20.0),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
                const SizedBox(
                  height: 20.0,
                ),
                BlocBuilder<SearchCubit, SearchState>(
                  buildWhen: (previous, current) {
                    return previous.searchPageStatus !=
                            current.searchPageStatus ||
                        previous.filteredProducts != current.filteredProducts;
                  },
                  builder: (context, state) {
                    if (state.searchPageStatus == SearchPageStatus.loading) {
                      return const LoadingWidget();
                    } else if (state.searchPageStatus ==
                        SearchPageStatus.error) {
                      return FailureWidget(error: state.errorMessage!);
                    } else if (state.searchPageStatus ==
                        SearchPageStatus.initial) {
                      return const SizedBox.shrink();
                    }

                    return ConditionalBuilder(
                      condition: state.filteredProducts.isEmpty &&
                          state.searchPageStatus != SearchPageStatus.clear,
                      builder: (context) {
                        return const EmptySearch();
                      },
                      fallback: (context) {
                        return ListView.builder(
                          shrinkWrap: true,
                          primary: false,
                          itemCount: state.filteredProducts.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              leading: Hero(
                                tag: state.filteredProducts[index].id,
                                child: Image.network(
                                  state.filteredProducts[index].images[0],
                                  width: 50.0,
                                  height: 150.0,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              title: BlocBuilder<ThemeCubit, ThemeState>(
                                builder: (context, theme) {
                                  return Text(
                                    state.filteredProducts[index].name,
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontFamily: FontFamilyManager.nunitoSans,
                                      fontWeight: FontWeight.w600,
                                      color: theme.isDarkMode
                                          ? ColorManager.white
                                          : ColorManager.black,
                                    ),
                                  );
                                },
                              ),
                              subtitle: Text(
                                'EGP ${state.filteredProducts[index].price}',
                                style: const TextStyle(
                                  fontSize: 18.0,
                                  color: ColorManager.indigo,
                                  fontFamily: FontFamilyManager.montserrat,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              trailing: Builder(
                                builder: (context) {
                                  return IconButton(
                                    splashRadius: 24.0,
                                    tooltip: 'Add to favorites',
                                    onPressed: () {
                                      context.read<UserBloc>().add(
                                            UserProductFavoriteToggled(
                                              context
                                                  .read<UserBloc>()
                                                  .state
                                                  .user
                                                  .favorites,
                                              state.filteredProducts[index],
                                            ),
                                          );
                                    },
                                    icon: Builder(
                                      builder: (context) {
                                        return Icon(
                                          context.select<UserBloc, bool>(
                                            (bloc) => bloc.isFavorite(state
                                                .filteredProducts[index].id),
                                          )
                                              ? Ionicons.heart
                                              : Ionicons.heart_outline,
                                          color: ColorManager.red,
                                          size: 30.0,
                                        );
                                      },
                                    ),
                                  );
                                },
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) {
                                      return BlocProvider.value(
                                        value: context.read<UserBloc>(),
                                        child: ProductScreen(
                                          state.filteredProducts[index],
                                        ),
                                      );
                                    },
                                  ),
                                );
                              },
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
