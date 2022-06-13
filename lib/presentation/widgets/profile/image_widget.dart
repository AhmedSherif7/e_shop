import 'package:flutter/material.dart';

class UserAvatarImage extends StatelessWidget {
  const UserAvatarImage(this.child, {Key? key}) : super(key: key);

  final ImageProvider child;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 65.0,
      backgroundColor: Colors.transparent,
      backgroundImage: child,
    );
  }
}
