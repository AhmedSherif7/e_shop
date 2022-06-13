part of 'theme_cubit.dart';

@immutable
class ThemeState extends Equatable {
  final bool isDarkMode;

  const ThemeState({
    this.isDarkMode = false,
  });

  @override
  List<Object?> get props => [
        isDarkMode,
      ];

  ThemeState copyWith({
    bool? isDarkMode,
  }) {
    return ThemeState(
      isDarkMode: isDarkMode ?? this.isDarkMode,
    );
  }
}
