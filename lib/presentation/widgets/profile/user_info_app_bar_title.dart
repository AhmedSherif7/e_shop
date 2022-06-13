import 'package:flutter/material.dart';

import '../../blocs/user_info/user_info_cubit.dart';

class UserInfoAppBarTitle extends StatelessWidget {
  const UserInfoAppBarTitle({
    required this.screenStatus,
    Key? key,
  }) : super(key: key);

  final ScreenStatus screenStatus;

  @override
  Widget build(BuildContext context) {
    String title = '';

    if (screenStatus == ScreenStatus.viewing ||
        screenStatus == ScreenStatus.infoUpdated) {
      title = 'My Information';
    } else {
      title = 'Edit My Information';
    }

    return Text(
      title,
    );
  }
}
