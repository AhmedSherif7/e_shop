part of 'home_carousel_cubit.dart';

class HomeCarouselState extends Equatable {
  final int childIndex;

  const HomeCarouselState({
    this.childIndex = 0,
  });

  @override
  List<Object?> get props => [childIndex];

  HomeCarouselState copyWith(int? index) {
    return HomeCarouselState(childIndex: index ?? childIndex);
  }
}
