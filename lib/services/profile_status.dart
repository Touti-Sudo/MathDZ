import 'package:flutter/material.dart';

class ProfileStatus {
  static ValueNotifier<String?> profilePicturePath = ValueNotifier(null);

  static void initProfilePicture(String? initialPath) {
    profilePicturePath.value = initialPath;
  }
}