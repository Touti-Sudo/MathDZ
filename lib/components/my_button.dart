import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final double radius;
  final Color? color;
  final double height;
  final double width;
  final String text;
  final void Function()? ontap;
  final TextStyle textstyle;
  const MyButton({
    super.key,
    required this.radius,
    required this.color,
    required this.text,
    required this.textstyle,
    required this.height,
    required this.width,
    required this.ontap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 3,
              spreadRadius: 2,
              offset: Offset(4, 4),
            ),
          ],
          color: color,
        ),
        child: Center(child: Text(text, style: textstyle)),
      ),
    );
  }
}
