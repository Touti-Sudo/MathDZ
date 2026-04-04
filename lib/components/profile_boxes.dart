import 'package:flutter/material.dart';

class ProfileBoxes extends StatelessWidget {
  final Color color;
  final BorderRadiusGeometry borderRadius;
  final Widget child;
  final String title;
  final TextStyle titlestyle;
  const ProfileBoxes({
    super.key,
    required this.color,
    required this.borderRadius,
    required this.title,
    required this.titlestyle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: borderRadius,
        border: Border.all(width: 1, color: Color.fromARGB(255, 194, 194, 194)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 15, right: 15, left: 15),
                child: Text(title, style: titlestyle),
              ),
            ],
          ),
          child,
        ],
      ),
    );
  }
}
