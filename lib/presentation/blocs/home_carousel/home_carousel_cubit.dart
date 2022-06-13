import 'package:bloc/bloc.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:equatable/equatable.dart';

part 'home_carousel_state.dart';

class HomeCarouselCubit extends Cubit<HomeCarouselState> {
  HomeCarouselCubit() : super(const HomeCarouselState());

  void changeChild(int index, CarouselPageChangedReason reason) {
    emit(state.copyWith(index));
  }
}
