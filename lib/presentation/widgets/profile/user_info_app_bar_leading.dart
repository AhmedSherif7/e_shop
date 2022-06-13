import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';

import '../../blocs/user_info/user_info_cubit.dart';

class UserInfoAppBarLeading extends StatelessWidget {
  const UserInfoAppBarLeading({
    required this.screenStatus,
    Key? key,
  }) : super(key: key);

  final ScreenStatus screenStatus;

  @override
  Widget build(BuildContext context) {
    late VoidCallback? onPressed;
    String toolTip = '';
    late IconData icon;

    if (screenStatus == ScreenStatus.viewing ||
        screenStatus == ScreenStatus.infoUpdated) {
      toolTip = 'Back';
      onPressed = () {
        Navigator.pop(context);
      };
      icon = Ionicons.chevron_back_outline;
    } else if (screenStatus == ScreenStatus.editing) {
      toolTip = 'Cancel';
      onPressed = () {
        context.read<UserInfoCubit>().reset();
      };
      icon = Ionicons.close_outline;
    } else {
      onPressed = null;
      icon = Ionicons.close_outline;
    }

    return IconButton(
      tooltip: toolTip,
      onPressed: onPressed,
      icon: Icon(icon),
    );
  }
}
