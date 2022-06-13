import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app/di.dart';
import 'presentation/blocs/bloc_observer.dart';
import 'presentation/blocs/theme/theme_cubit.dart';
import 'presentation/resources/routes_manager.dart';
import 'presentation/resources/themes_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initAppModule();

  BlocOverrides.runZoned(
    () {
      runApp(const MyApp());
    },
    blocObserver: MyBlocObserver(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ThemeCubit>()..getThemeFromStorage(),
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'E-Shop App',
            theme: ThemeManager().light,
            darkTheme: ThemeManager().dark,
            themeMode: state.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            onGenerateRoute: RouteGenerator.getRoute,
          );
        },
      ),
    );
  }
}
