import 'dart:io';
import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  final String? imagePath;


  const ProfileAvatar({
    super.key,
    this.imagePath,

  });

  @override
  Widget build(BuildContext context) {
    ImageProvider imageProvider;

    if (imagePath != null && File(imagePath!).existsSync()) {
      imageProvider = FileImage(File(imagePath!));
    } else {
      imageProvider = const AssetImage('assets/user.png');
    }

    return CircleAvatar(
      radius: 40,
      backgroundImage: imageProvider,
    );
  }
}
