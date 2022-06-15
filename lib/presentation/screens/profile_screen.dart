import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:flutter_switch/flutter_switch.dart';

import '../../app/functions.dart';
import '../blocs/theme/theme_cubit.dart';
import '../blocs/user/user_bloc.dart';
import '../resources/colors_manager.dart';
import '../resources/font_manager.dart';
import '../resources/routes_manager.dart';
import '../widgets/profile/profile_item_list_tile.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        if (state.userDataStatus == UserDataStatus.logoutSuccess) {
          Navigator.pushReplacementNamed(
            context,
            Routes.splash,
            arguments: true,
          );
        } else if (state.userDataStatus == UserDataStatus.logoutError) {
          showToast(
            message: state.message!,
            state: ToastStates.error,
          );
        }
      },
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 12.0, 8.0, 8.0),
          child: Column(
            children: [
              BlocBuilder<ThemeCubit, ThemeState>(
                builder: (context, state) {
                  return CircleAvatar(
                    radius: 68.0,
                    backgroundColor: state.isDarkMode
                        ? ColorManager.white
                        : ColorManager.black,
                    child: Builder(
                      builder: (context) {
                        return CircleAvatar(
                          radius: 65.0,
                          backgroundColor: Colors.transparent,
                          backgroundImage: CachedNetworkImageProvider(
                            context.select<UserBloc, String>(
                              (value) => value.state.user.imageUrl,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
              const SizedBox(
                height: 10.0,
              ),
              BlocBuilder<UserBloc, UserState>(
                buildWhen: (previous, current) =>
                    previous.user.firstName != current.user.firstName ||
                    previous.user.lastName != current.user.lastName,
                builder: (context, state) {
                  return BlocBuilder<ThemeCubit, ThemeState>(
                    builder: (context, theme) {
                      return Text(
                        '${state.user.firstName} ${state.user.lastName}',
                        style: TextStyle(
                          color: theme.isDarkMode
                              ? ColorManager.white
                              : ColorManager.black,
                          fontSize: 26.0,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w700,
                        ),
                      );
                    },
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Container(
                  child: Center(
                    child: Text(
                      'Member since: ${DateFormat('dd-MMM-yyyy').format(DateTime.parse(context.read<UserBloc>().state.user.memberSince))}',
                      style: const TextStyle(
                        color: ColorManager.black,
                        fontSize: 16.0,
                        fontFamily: FontFamilyManager.nunitoSans,
                      ),
                    ),
                  ),
                  height: 60.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    color: ColorManager.lightGrey350,
                  ),
                ),
              ),
              ProfileItemListTile(
                leading: Ionicons.briefcase,
                title: 'Orders',
                onTap: () {
                  Navigator.pushNamed(context, Routes.orders);
                },
              ),
              ProfileItemListTile(
                leading: Ionicons.heart,
                title: 'Favorites',
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    Routes.favorites,
                    arguments: context.read<UserBloc>(),
                  );
                },
              ),
              ProfileItemListTile(
                leading: Ionicons.information_circle,
                title: 'Personal Information',
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    Routes.userInfo,
                    arguments: context.read<UserBloc>(),
                  );
                },
              ),
              BlocBuilder<ThemeCubit, ThemeState>(
                builder: (context, state) {
                  return FlutterSwitch(
                    width: 80.0,
                    height: 40.0,
                    valueFontSize: 25.0,
                    toggleSize: 30.0,
                    value: state.isDarkMode,
                    borderRadius: 30.0,
                    padding: 8.0,
                    showOnOff: false,
                    activeColor: ColorManager.grey,
                    inactiveColor: ColorManager.grey,
                    activeIcon: const Icon(Ionicons.sunny),
                    inactiveIcon: const Icon(Ionicons.moon),
                    onToggle: context.read<ThemeCubit>().toggleThemeMode,
                  );
                },
              ),
              TextButton.icon(
                style: ButtonStyle(
                  overlayColor: MaterialStateProperty.all(
                    ColorManager.lightGrey350,
                  ),
                ),
                onPressed: () {
                  context.read<UserBloc>().add(UserLoggedOut());
                },
                icon: const Icon(
                  Ionicons.log_out_outline,
                  color: ColorManager.red,
                  size: 26.0,
                ),
                label: const Text(
                  'Sign out',
                  style: TextStyle(
                    color: ColorManager.red,
                    fontSize: 20.0,
                    fontFamily: FontFamilyManager.montserrat,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
