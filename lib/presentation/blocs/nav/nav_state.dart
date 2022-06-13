part of 'nav_cubit.dart';

class NavState extends Equatable {
  final int pageIndex;
  final List<Map<String, dynamic>> screens = const [
    {
      'title' : 'Home',
      'body' : HomeScreen(),
    },
    {
      'title' : 'Categories',
      'body' : CategoriesScreen(),
    },
    {
      'title' : 'Cart',
      'body' : CartScreen(),
    },
    {
      'title' : 'Profile',
      'body' : ProfileScreen(),
    },
  ];

  const NavState({
    this.pageIndex = 0,
  });

  @override
  List<Object?> get props => [pageIndex];

  NavState copyWith(int? index) {
    return NavState(pageIndex: index ?? pageIndex);
  }
}
