import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import 'package:lottie/lottie.dart';

import '../../blocs/user_info/user_info_cubit.dart';
import '../../resources/assets_manager.dart';
import '../../resources/colors_manager.dart';
import '../../resources/font_manager.dart';

class BottomSheetContent extends StatelessWidget {
  const BottomSheetContent({
    required this.text,
    this.child,
    Key? key,
  }) : super(key: key);

  final String text;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300.0,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LottieBuilder.asset(
              AssetJsonManager.error,
              repeat: false,
              height: 80.0,
              width: 80.0,
            ),
            Text(
              text,
              style: const TextStyle(
                fontSize: 24.0,
                color: ColorManager.black,
                fontFamily: FontFamilyManager.nunitoSans,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                if (child != null) child!,
                ElevatedButton.icon(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      ColorManager.black38,
                    ),
                  ),
                  onPressed: () {
                    context.read<UserInfoCubit>().getLocation();
                  },
                  icon: const Icon(Ionicons.reload),
                  label: const Text('Retry'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
