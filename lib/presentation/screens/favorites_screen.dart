import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';

import '../blocs/user/user_bloc.dart';
import '../widgets/favorites/empty_favorites.dart';
import '../widgets/favorites/favorites_products_list_view.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Ionicons.chevron_back),
        ),
        title: const Text('Favorites'),
      ),
      body: BlocSelector<UserBloc, UserState, int>(
        selector: (state) {
          return state.user.favorites.length;
        },
        builder: (context, favoriteProducts) {
          return ConditionalBuilder(
            condition: favoriteProducts > 0,
            builder: (context) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: FavoritesProductsListView(
                  context.read<UserBloc>().state.user.favorites,
                ),
              );
            },
            fallback: (context) {
              return const EmptyFavorites();
            },
          );
        },
      ),
    );
  }
}
