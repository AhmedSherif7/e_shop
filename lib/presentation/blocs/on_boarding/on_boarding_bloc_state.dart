part of 'on_boarding_bloc_cubit.dart';

enum Status {
  success,
  error,
}

@immutable
class OnBoardingCubitState extends Equatable {
  final Status? status;
  final int pageIndex;
  final List<Widget> widgets;

  const OnBoardingCubitState({
    this.status,
    this.pageIndex = 0,
    this.widgets = const [
      OnBoardingScreenBody(
        image: AssetImageManager.onBoardingFirstScreen,
        title: 'Get anything online',
        subtitle: 'You can buy anything you want with few clicks.',
      ),
      OnBoardingScreenBody(
        image: AssetImageManager.onBoardingSecondScreen,
        title: 'Shipping to anywhere',
        subtitle: 'We ship to anywhere in Egypt, With 100% money back policy.',
      ),
      OnBoardingScreenBody(
        image: AssetImageManager.onBoardingThirdScreen,
        title: 'On-time delivery',
        subtitle: 'You can track your orders with our tracking service.',
      ),
      OnBoardingScreenBody(
        image: AssetImageManager.onBoardingFourthScreen,
        title: 'Pay with any method',
        subtitle: 'Pay online or on delivery and manage your account balance.',
      ),
    ],
  });

  @override
  List<Object?> get props => [
        status,
        pageIndex,
      ];

  OnBoardingCubitState copyWith({
    Status? status,
    int? pageIndex,
  }) {
    return OnBoardingCubitState(
      status: status ?? this.status,
      pageIndex: pageIndex ?? this.pageIndex,
    );
  }
}
