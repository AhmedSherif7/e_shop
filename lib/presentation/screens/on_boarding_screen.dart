import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../app/di.dart';
import '../blocs/on_boarding/on_boarding_bloc_cubit.dart';
import '../resources/assets_manager.dart';
import '../resources/colors_manager.dart';
import '../resources/routes_manager.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<OnBoardingCubit>(
      create: (_) => sl<OnBoardingCubit>(),
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 0.0,
          backgroundColor: ColorManager.lightGrey100,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: ColorManager.lightGrey100,
            statusBarIconBrightness: Brightness.dark,
          ),
        ),
        body: SafeArea(
          child: Container(
            decoration: const BoxDecoration(
              color: ColorManager.lightGrey100,
              image: DecorationImage(
                image: AssetImage(AssetImageManager.onBoardingBackground),
              ),
            ),
            child: BlocConsumer<OnBoardingCubit, OnBoardingCubitState>(
              listenWhen: (previous, current) =>
                  previous.status != current.status,
              listener: (context, state) {
                if (state.status == Status.success) {
                  Navigator.pushReplacementNamed(
                    context,
                    Routes.register,
                  );
                }
              },
              buildWhen: (previous, current) =>
                  previous.pageIndex != current.pageIndex,
              builder: (context, state) {
                return Stack(
                  children: [
                    PageView.builder(
                      itemCount: state.widgets.length,
                      controller: _pageController,
                      onPageChanged:
                          context.read<OnBoardingCubit>().changePageIndex,
                      itemBuilder: (context, index) {
                        return state.widgets[index];
                      },
                    ),
                    Positioned(
                      bottom: 16.0,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          children: [
                            SmoothPageIndicator(
                              controller: _pageController,
                              count: state.widgets.length,
                              onDotClicked: (index) {
                                _pageController.animateToPage(
                                  index,
                                  duration: const Duration(
                                    milliseconds: 500,
                                  ),
                                  curve: Curves.linear,
                                );
                              },
                              effect: const SwapEffect(
                                dotHeight: 14.0,
                                dotWidth: 14.0,
                                spacing: 12.0,
                                activeDotColor: ColorManager.primary,
                                dotColor: ColorManager.black,
                                paintStyle: PaintingStyle.stroke,
                                strokeWidth: 0.8,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Opacity(
                                  opacity: state.pageIndex !=
                                          state.widgets.length - 1
                                      ? 1.0
                                      : 0.0,
                                  child: TextButton(
                                    style: ButtonStyle(
                                      overlayColor: MaterialStateProperty.all(
                                        Colors.transparent,
                                      ),
                                    ),
                                    child: const Text(
                                      'SKIP',
                                      style: TextStyle(
                                        color: ColorManager.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.0,
                                      ),
                                    ),
                                    onPressed: () {
                                      if (state.pageIndex !=
                                          state.widgets.length - 1) {
                                        context
                                            .read<OnBoardingCubit>()
                                            .watchOnBoarding();
                                      }
                                    },
                                  ),
                                ),
                                ConditionalBuilder(
                                  condition: state.pageIndex !=
                                      state.widgets.length - 1,
                                  builder: (context) {
                                    return TextButton(
                                      style: ButtonStyle(
                                        overlayColor: MaterialStateProperty.all(
                                          Colors.transparent,
                                        ),
                                      ),
                                      child: const Text(
                                        'NEXT',
                                        style: TextStyle(
                                          color: ColorManager.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.0,
                                        ),
                                      ),
                                      onPressed: () {
                                        if (_pageController.page !=
                                            state.widgets.length - 1) {
                                          _pageController.nextPage(
                                            duration: const Duration(
                                              milliseconds: 200,
                                            ),
                                            curve: Curves.linear,
                                          );
                                        }
                                      },
                                    );
                                  },
                                  fallback: (context) {
                                    return TextButton(
                                      style: ButtonStyle(
                                        overlayColor: MaterialStateProperty.all(
                                          Colors.transparent,
                                        ),
                                      ),
                                      child: const Text(
                                        'FINISH',
                                        style: TextStyle(
                                          color: ColorManager.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.0,
                                        ),
                                      ),
                                      onPressed: () {
                                        context
                                            .read<OnBoardingCubit>()
                                            .watchOnBoarding();
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
