import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../screens/cart_screen.dart';
import '../../screens/categories_screen.dart';
import '../../screens/home_screen.dart';
import '../../screens/profile_screen.dart';

part 'nav_state.dart';

class NavCubit extends Cubit<NavState> {
  NavCubit() : super(const NavState());

  void changeScreen(int index) {
    emit(state.copyWith(index));
  }
}
