import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app/di.dart';
import '../blocs/home/home_cubit.dart';
import '../blocs/user/user_bloc.dart';
import '../resources/colors_manager.dart';
import '../widgets/error_widget.dart';
import '../widgets/loading_widget.dart';
import 'category_screen.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      buildWhen: (previous, current) =>
          previous.categories != current.categories,
      builder: (context, state) {
        return FadeInLeft(
          child: ListView.separated(
            itemCount: state.categories.length,
            itemBuilder: (context, index) {
              if (state.status == HomeStatus.loading) {
                return const Center(
                  child: LoadingWidget(),
                );
              } else if (state.status == HomeStatus.error) {
                return const Center(
                  child: FailureWidget(),
                );
              }
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Container(
                  width: double.infinity,
                  height: 160.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: CachedNetworkImageProvider(
                        state.categories[index].image,
                      ),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        state.categories[index].name,
                        style: const TextStyle(
                          color: ColorManager.white,
                          fontSize: 26.0,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              color: ColorManager.black,
                              offset: Offset(0, 0),
                              blurRadius: 14.0,
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) {
                                initCategoriesModule();
                                return BlocProvider<UserBloc>.value(
                                  value: context.read<UserBloc>(),
                                  child: CategoryScreen(
                                    state.categories[index].name,
                                  ),
                                );
                              },
                            ),
                          );
                        },
                        style: ButtonStyle(
                          elevation: MaterialStateProperty.all(10.0),
                          backgroundColor: MaterialStateProperty.all(
                            ColorManager.white,
                          ),
                          shape: MaterialStateProperty.all(
                            const StadiumBorder(),
                          ),
                          fixedSize: MaterialStateProperty.all(
                            const Size(120.0, 20.0),
                          ),
                        ),
                        child: const Text(
                          'View',
                          style: TextStyle(
                            color: ColorManager.black,
                            fontSize: 14.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) {
              return const SizedBox(
                height: 20.0,
              );
            },
          ),
        );
      },
    );
  }
}
