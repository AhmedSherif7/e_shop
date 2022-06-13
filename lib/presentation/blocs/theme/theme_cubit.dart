import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../domain/use_cases/base_use_case.dart';
import '../../../domain/use_cases/get_theme_from_storage_use_case.dart';
import '../../../domain/use_cases/toggle_theme_use_case.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit(
    this.toggleThemeUseCase,
    this.getThemeFromStorageUseCase,
  ) : super(const ThemeState());

  final ToggleThemeUseCase toggleThemeUseCase;
  final GetThemeFromStorageUseCase getThemeFromStorageUseCase;

  void getThemeFromStorage() async {
    final result = await getThemeFromStorageUseCase(NoParams());
    result.fold(
      (failure) {
        emit(
          state.copyWith(
            isDarkMode: false,
          ),
        );
      },
      (result) {
        emit(
          state.copyWith(
            isDarkMode: result,
          ),
        );
      },
    );
  }

  void toggleThemeMode(bool value) async {
    emit(
      state.copyWith(
        isDarkMode: value,
      ),
    );

    await toggleThemeUseCase(value);
  }
}
