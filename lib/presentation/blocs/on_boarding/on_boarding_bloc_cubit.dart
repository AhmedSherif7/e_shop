import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../domain/use_cases/base_use_case.dart';
import '../../../domain/use_cases/watch_onboarding_use_case.dart';
import '../../resources/assets_manager.dart';
import '../../widgets/on_boarding/on_boarding_screen_body.dart';

part 'on_boarding_bloc_state.dart';

class OnBoardingCubit extends Cubit<OnBoardingCubitState> {
  OnBoardingCubit(this.watchOnBoardingUseCase)
      : super(const OnBoardingCubitState());

  final WatchOnBoardingUseCase watchOnBoardingUseCase;

  void changePageIndex(int index) {
    emit(
      state.copyWith(
        pageIndex: index,
      ),
    );
  }

  void watchOnBoarding() async {
    final result = await watchOnBoardingUseCase(NoParams());
    result.fold(
      (error) {
        emit(
          state.copyWith(
            status: Status.error,
          ),
        );
      },
      (success) {
        emit(
          state.copyWith(
            status: Status.success,
          ),
        );
      },
    );
  }
}
