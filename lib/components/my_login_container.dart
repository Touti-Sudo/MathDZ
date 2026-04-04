import 'package:flutter/material.dart';

class MyLoginContainer extends StatelessWidget {
  final String path;
  final double heigth;
  final double width;
  final Color? color;
  final void Function()? onTap;
  const MyLoginContainer({
    super.key,
    required this.onTap,
    required this.path,
    required this.heigth,
    required this.width,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: color,
        ),
        child: Image.asset(path, height: heigth, width: width),
      ),
    );
  }
}
