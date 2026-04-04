import 'dart:io';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mathdz/services/profile_avatare.dart';
import 'package:path_provider/path_provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final user = FirebaseAuth.instance.currentUser;
  String? profilePicturePath;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox.expand(
            child: Image.asset("assets/Background.png", fit: BoxFit.cover),
          ),
          Column(
            children: [
              SizedBox(height: 150),
              Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        final picker = ImagePicker();
                        final pickedFile = await picker.pickImage(
                          source: ImageSource.gallery,
                        );
                        if (pickedFile == null) return;

                        final appDir = await getApplicationDocumentsDirectory();
                        final fileName = basename(pickedFile.path);
                        final savedImage = await File(
                          pickedFile.path,
                        ).copy('${appDir.path}/$fileName');

                        final uid = FirebaseAuth.instance.currentUser?.uid;
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
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(color: Colors.white),
                child: Text(
                  user?.displayName ?? "anonymous",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: Container(
                  decoration: BoxDecoration(color: Colors.white),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      user?.email ?? "",
                      style: TextStyle(fontSize: 11),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Card(
                  color: Colors.amber[200],
                  child: ListTile(
                    title: Text("إعدادات الحساب"),
                    leading: CircleAvatar(
                      backgroundColor: Colors.amberAccent[100],
                      child: Icon(Icons.person, color: Colors.amber[700]),
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, "profilesettings");
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Card(
                  color: Colors.amber[200],
                  child: ListTile(
                    title: Text("سياسة الخصوصية"),
                    leading: Icon(
                      Icons.menu_book_rounded,
                      color: Colors.greenAccent[700],
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, "privacypolicy");
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Card(
                  color: Colors.amber[200],
                  child: ListTile(
                    title: Text("المساعدة والدعم"),
                    leading: CircleAvatar(
                      backgroundColor: Colors.lightBlueAccent[100],
                      child: Icon(
                        Icons.question_mark_rounded,
                        color: Colors.lightBlue[700],
                      ),
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, "helpandsupport");
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Card(
                  color: Colors.amber[200],
                  child: ListTile(
                    title: Text(
                      "تسجيل الخروج",
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    leading: Icon(Icons.logout, color: Colors.redAccent[700]),
                    onTap: () {
                      FirebaseAuth.instance.signOut();
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
