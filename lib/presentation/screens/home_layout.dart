import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';

import '../../app/di.dart';
import '../../app/functions.dart';
import '../blocs/home/home_cubit.dart';
import '../blocs/nav/nav_cubit.dart';
import '../blocs/user/user_bloc.dart';
import '../resources/routes_manager.dart';
import '../widgets/error_widget.dart';
import '../widgets/home/bottom_nav_bar.dart';
import '../widgets/loading_widget.dart';

class HomeLayout extends StatelessWidget {
  const HomeLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<UserBloc>(
          create: (_) => sl<UserBloc>()..add(UserDataFetched()),
        ),
        BlocProvider<HomeCubit>(
          create: (_) => sl<HomeCubit>()..getHomeProducts(),
        ),
        BlocProvider<NavCubit>(
          create: (_) => NavCubit(),
        ),
      ],
      child: BlocListener<UserBloc, UserState>(
        listenWhen: (previous, current) {
          return previous.userProductStatus != current.userProductStatus ||
              (previous.user.cartProducts.length !=
                      current.user.cartProducts.length &&
                  current.notifyCartChange) ||
              previous.user.favorites.length != current.user.favorites.length;
        },
        listener: (context, state) {
          switch (state.userProductStatus) {
            case UserProductStatus.addedToFavoritesSuccess:
            case UserProductStatus.addedToCartSuccess:
            case UserProductStatus.removedFromFavoritesSuccess:
            case UserProductStatus.removedFromCartSuccess:
            case UserProductStatus.addedToFavoritesError:
            case UserProductStatus.removedFromFavoritesError:
            case UserProductStatus.addedToCartError:
            case UserProductStatus.removedFromCartError:
              showToast(
                message: state.message!,
                state: ToastStates.success,
              );
              break;
            case null:
              break;
          }
        },
        child: BlocBuilder<NavCubit, NavState>(
          buildWhen: (previous, current) =>
              previous.pageIndex != current.pageIndex,
          builder: (context, navState) {
            return Scaffold(
              appBar: AppBar(
                title: Text(navState.screens[navState.pageIndex]['title']),
                actions: [
                  IconButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        Routes.search,
                        arguments: context.read<UserBloc>(),
                      );
                    },
                    icon: const Icon(
                      Ionicons.search,
                    ),
                  ),
                ],
              ),
              body: SafeArea(
                child: BlocBuilder<HomeCubit, HomeState>(
                  buildWhen: (previous, current) =>
                      previous.status != current.status,
                  builder: (context, state) {
                    if (state.status == HomeStatus.error) {
                      return Center(
                        child: FailureWidget(error: state.message!),
                      );
                    } else if (state.status == HomeStatus.loading) {
                      return const Center(
                        child: LoadingWidget(),
                      );
                    }

                    return navState.screens[navState.pageIndex]['body'];
                  },
                ),
              ),
              bottomNavigationBar: const BottomNavBar(),
            );
          },
        ),
      ),
    );
  }
}
