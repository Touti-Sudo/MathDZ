import 'dart:io';
import 'package:mathdz/components/profile_boxes.dart';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mathdz/services/profile_avatare.dart';
import 'package:path_provider/path_provider.dart';

class ProfileSettings extends StatefulWidget {
  const ProfileSettings({super.key});

  @override
  State<ProfileSettings> createState() => _ProfileSettingsState();
}

class _ProfileSettingsState extends State<ProfileSettings> {
  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String? profilePicturePath;

  @override
  void dispose() {
    userNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void connexion() async {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );
        if (!mounted) return;
        Navigator.pop(context);
      } on FirebaseAuthException catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.message ?? 'فشل تسجيل الدخول')));
      }
    }

    void showlogin() async {
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text(
            "نحتاج إلى التحقق من أنك أنت من يرغب فعلاً في حذف الحساب. يرجى تسجيل الدخول مرة أخرى.",
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  hintText: 'أدخل عنوان بريدك الإلكتروني',
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: 'أدخل كلمة المرور الخاصة بك',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                await connexion;
                final user = FirebaseAuth.instance.currentUser;
                await user?.delete();
              },
              child: const Text('التأكيد'),
            ),
          ],
        ),
      );
    }

    void restpassword() async {
      final user = FirebaseAuth.instance.currentUser;
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: '${user!.email}',
      );
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Text(
            'تم إرسال بريد إلكتروني إلى صندوق بريدك الوارد. اتبع التعليمات لإعادة تعيين كلمة مرورك.',
          ),
        ),
      );
    }

    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amberAccent,
        title: Row(children: [Text("إعدادات الحساب")]),
      ),
      body: user == null
          ? const Center(child: Text("لا يوجد مستخدم مسجل دخوله حاليًا."))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ProfileBoxes(
                    titlestyle: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                    title: "التفاصيل الأساسية",
                    color: Colors.white,
                    borderRadius: BorderRadiusGeometry.circular(15),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  final picker = ImagePicker();
                                  final pickedFile = await picker.pickImage(
                                    source: ImageSource.gallery,
                                  );
                                  if (pickedFile == null) return;

                                  final appDir =
                                      await getApplicationDocumentsDirectory();
                                  final fileName = basename(pickedFile.path);
                                  final savedImage = await File(
                                    pickedFile.path,
                                  ).copy('${appDir.path}/$fileName');

                                  final uid =
                                      FirebaseAuth.instance.currentUser?.uid;
                                  if (uid != null) {
                                    await FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(uid)
                                        .set({
                                          'profilePicture': savedImage.path,
                                        }, SetOptions(merge: true));
                                  }

                                  setState(() {
                                    profilePicturePath = savedImage.path;
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: ProfileAvatar(
                                    imagePath: profilePicturePath,
                                    imageUrl: user?.photoURL,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextButton(
                                  child: Text(
                                    "تغيير الصورة",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                  onPressed:() async {
                                  final picker = ImagePicker();
                                  final pickedFile = await picker.pickImage(
                                    source: ImageSource.gallery,
                                  );
                                  if (pickedFile == null) return;

                                  final appDir =
                                      await getApplicationDocumentsDirectory();
                                  final fileName = basename(pickedFile.path);
                                  final savedImage = await File(
                                    pickedFile.path,
                                  ).copy('${appDir.path}/$fileName');

                                  final uid =
                                      FirebaseAuth.instance.currentUser?.uid;
                                  if (uid != null) {
                                    await FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(uid)
                                        .set({
                                          'profilePicture': savedImage.path,
                                        }, SetOptions(merge: true));
                                  }

                                  setState(() {
                                    profilePicturePath = savedImage.path;
                                  });
                                },
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    top: 20,
                                    bottom: 8,
                                  ),
                                  child: TextField(
                                    cursorColor: Colors.black54,
                                    controller: userNameController,
                                    decoration: InputDecoration(
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: const Color.fromARGB(
                                            255,
                                            253,
                                            204,
                                            26,
                                          ),
                                        ),
                                      ),
                                      labelText: "اسم المستخدم",
                                      labelStyle: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                      hint: Text(
                                        user.displayName ?? "anonyme",
                                        style: TextStyle(
                                          color: Colors.grey[500],
                                        ),
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  FirebaseAuth.instance.currentUser
                                      ?.updateDisplayName(
                                        userNameController.text,
                                      );
                                },
                                child: Text(
                                  "الحفظ",
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: ProfileBoxes(
                      color: Colors.white,
                      borderRadius: BorderRadiusGeometry.circular(15),
                      title: "إعدادات الملف الشخصي",
                      titlestyle: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              TextButton.icon(
                                onPressed: restpassword,
                                label: Text(
                                  "إعادة تعيين كلمة المرور",
                                  style: TextStyle(color: Colors.black),
                                ),
                                icon: Icon(Icons.security),
                                style: ButtonStyle(
                                  iconColor: WidgetStateProperty.all(
                                    Colors.lightBlueAccent,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.redAccent.withAlpha(200),
                                  Colors.redAccent.withAlpha(2),
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                              borderRadius: BorderRadius.circular(2),
                            ),
                            width: double.infinity,
                            height: 90,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "منطقة خطرة",
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 60,
                            width: double.infinity,
                            child: Container(
                              width: double.infinity,

                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Theme.of(context).colorScheme.surface,
                              ),
                              child: TextButton(
                                style: ButtonStyle(
                                  alignment: Alignment.centerLeft,
                                ),
                                onPressed: () async {
                                  final user =
                                      FirebaseAuth.instance.currentUser;
                                  showlogin();
                                  await user?.delete();
                                },
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.account_box_rounded,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.secondary,
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      'حذف المستخدم',
                                      style: TextStyle(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.secondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
