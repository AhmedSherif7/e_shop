import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/theme/theme_cubit.dart';
import '../../resources/colors_manager.dart';
import '../../resources/font_manager.dart';

class ProfileItemListTile extends StatelessWidget {
  const ProfileItemListTile({
    Key? key,
    required this.leading,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  final IconData leading;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          return Icon(
            leading,
            color: state.isDarkMode ? ColorManager.white : ColorManager.black,
          );
        },
      ),
      title: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          return Text(
            title,
            style: TextStyle(
              fontSize: 20.0,
              fontFamily: FontFamilyManager.nunitoSans,
              color: state.isDarkMode ? ColorManager.white : ColorManager.black,
            ),
          );
        },
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        color: ColorManager.primary,
      ),
      onTap: onTap,
    );
  }
}
