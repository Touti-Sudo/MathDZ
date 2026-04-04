import 'dart:io';
import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  final String? imagePath;
  final String? imageUrl;

  const ProfileAvatar({
    super.key,
    this.imagePath,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    ImageProvider imageProvider;

    if (imagePath != null && File(imagePath!).existsSync()) {
      imageProvider = FileImage(File(imagePath!));
    } else if (imageUrl != null && imageUrl!.isNotEmpty) {
      imageProvider = NetworkImage(imageUrl!);
    } else {
      imageProvider = const AssetImage('assets/user.png');
    }

    return CircleAvatar(
      radius: 40,
      backgroundImage: imageProvider,
    );
  }
}
