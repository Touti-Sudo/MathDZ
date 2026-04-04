import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mathdz/components/my_button.dart';
import 'package:mathdz/components/my_login_container.dart';
import 'package:mathdz/services/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool value = true;
  Future<void> _showErrorDialog(String title, String message) async {
    if (!mounted) return;

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        icon: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [Icon(Icons.error_outline, size: 40)],
        ),
        shadowColor: Colors.black,

        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  void signuserin() async {
    if (!mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      if (!mounted) return;
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      Navigator.of(context).pop();

      if (e.code == "user-not-found") {
        await _showErrorDialog(
          "No email found",
          "We couldn't find an account with this email.",
        );
      } else if (e.code == "wrong-password") {
        await _showErrorDialog(
          "Incorrect password",
          "Please check your password and try again.",
        );
      } else {
        await _showErrorDialog(
          "Error",
          "Please check your email and password.",
        );
      }
    } catch (e) {
      if (!mounted) return;
      Navigator.of(context).pop();
      await _showErrorDialog("Error", e.toString());
    }
  }

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[900],
      body: Stack(
        children: [
          Image.asset("assets/App-footer.png"),
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 250 * 0.7),
                Padding(
                  padding: const EdgeInsets.only(
                    right: 20,
                    left: 20,
                    bottom: 15,
                    top: 20,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 3,
                          spreadRadius: 2,
                          offset: Offset(4, 4),
                        ),
                      ],
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: [
                        Padding(
                              padding: const EdgeInsets.only(top:10),
                              child: Image.asset("assets/Icon.png",height: 100,),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                bottom: 5,
                                top: 5,
                              ),
                          child: Text(
                            "تسجيل الدخول",
                            style: TextStyle(
                              color: Colors.amber[600],
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                              fontStyle: FontStyle.normal,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 30,left: 40,right: 40,top: 30),
                          child: TextField(
                            cursorColor: Colors.blue,
                            controller: emailController,
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.mail,
                                color: Colors.black54,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              filled: true,

                              fillColor: Colors.white,
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              labelText: "بريد إلكتروني",
                              labelStyle: TextStyle(
                                color: Colors.black54,
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                              ),
                              floatingLabelStyle: TextStyle(
                                color: Colors.black54,
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                              ),
                              hintText: "exapmle@gmail.com",
                              hintStyle: TextStyle(color: Colors.black54),
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(
                            right: 40,
                            left: 40,
                            bottom: 10,
                          ),
                          child: TextField(
                            cursorColor: Colors.blue,
                            obscureText: value,

                            controller: passwordController,
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.lock,
                                color: Colors.black54,
                              ),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    value = !value;
                                  });
                                },
                                icon: value
                                    ? Icon(
                                        Icons.remove_red_eye,
                                        color: Colors.black54,
                                      )
                                    : Icon(
                                        Icons.remove_red_eye_outlined,
                                        color: Colors.black54,
                                      ),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              labelText: "كلمة المرور",
                              labelStyle: TextStyle(
                                color: Colors.black54,
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                              ),
                              floatingLabelStyle: TextStyle(
                                color: Colors.black54,
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 40, top: 10),
                          child: MyButton(
                            radius: 25,
                            color: Colors.amber[600],
                            text: "تسجيل الدخول",
                            textstyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 17,
                            ),
                            height: 60,
                            width: 250,
                            ontap: signuserin,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0, bottom: 5),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(thickness: 1, color: Colors.white),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 5, left: 5),
                        child: Text(
                          "أو قم بالتسجيل ب",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(thickness: 1, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: MyLoginContainer(
                    path: "assets/google.png",
                    heigth: 40,
                    width: 40,
                    color: Colors.white,
                    onTap: () async {
                      final user = await AuthService().signinWithGoogle();
                      if (user != null && mounted) {
                        Navigator.pushReplacementNamed(context, "homepage");
                      }
                    },
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      " ليس لديك حساب ؟",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, "registerpage");
                          },
                          child: Text(
                            "إنشاء حساب",
                            style: TextStyle(
                              color: Colors.amber[700],
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
