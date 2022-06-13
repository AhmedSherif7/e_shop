import 'package:flutter/material.dart';

import '../resources/colors_manager.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    Key? key,
    required this.onTap,
    required this.title,
    this.height = 60,
    this.color,
  }) : super(key: key);

  final VoidCallback? onTap;
  final String title;
  final double height;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width / 2,
        height: height,
        child: Center(
          child: Text(
            title,
            style: const TextStyle(
              color: Color(0xfffefefe),
              fontWeight: FontWeight.w600,
              fontStyle: FontStyle.normal,
              fontSize: 20.0,
            ),
          ),
        ),
        decoration: BoxDecoration(
          color: onTap != null ? color : ColorManager.lightGrey300,
          gradient: color != null
              ? null
              : LinearGradient(
                  colors: onTap != null
                      ? const [
                          Color.fromRGBO(236, 60, 3, 1),
                          Color.fromRGBO(234, 60, 3, 1),
                          Color.fromRGBO(216, 78, 16, 1),
                        ]
                      : const [
                          ColorManager.lightGrey300,
                          ColorManager.grey,
                        ],
                  begin: FractionalOffset.topCenter,
                  end: FractionalOffset.bottomCenter,
                ),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.16),
              offset: Offset(0, 5),
              blurRadius: 10.0,
            ),
          ],
          borderRadius: BorderRadius.circular(9.0),
        ),
      ),
    );
  }
}
