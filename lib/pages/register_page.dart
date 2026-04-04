import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mathdz/components/my_button.dart';
import 'package:mathdz/components/my_login_container.dart';
import 'package:mathdz/services/auth_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool value = true;
  bool value1 = true;
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

void signup() async {
  if (!mounted) return;

  // ✅ Validate first
  if (emailController.text.trim().isEmpty ||
      passwordController.text.trim().isEmpty ||
      confirmPasswordController.text.trim().isEmpty ||
      userNameController.text.trim().isEmpty) {
    await _showErrorDialog("Error", "Please fill all fields");
    return;
  }

  if (passwordController.text != confirmPasswordController.text) {
    await _showErrorDialog(
      "Passwords don't match",
      "Please confirm your password!",
    );
    return;
  }

  if (passwordController.text.length < 6) {
    await _showErrorDialog(
      "Weak password",
      "Password must be at least 6 characters",
    );
    return;
  }

  // ✅ Show loader AFTER validation
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => const Center(child: CircularProgressIndicator()),
  );

  try {
    UserCredential userCredential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );

    final user = userCredential.user;
    if (user != null) {
      await user.updateDisplayName(userNameController.text.trim());
    }

    if (!mounted) return;
    Navigator.of(context).pop();

    Navigator.pushReplacementNamed(context, "homepage");
  } on FirebaseAuthException catch (e) {
    if (!mounted) return;
    Navigator.of(context).pop();

    String message;

    switch (e.code) {
      case "email-already-in-use":
        message = "This email is already registered.";
        break;
      case "invalid-email":
        message = "Enter a valid email.";
        break;
      case "weak-password":
        message = "Password must be at least 6 characters.";
        break;
      default:
        message = e.message ?? "Unexpected error";
    }

    await _showErrorDialog("Error", message);
  } catch (e) {
    if (!mounted) return;
    Navigator.of(context).pop();
    await _showErrorDialog("Error", e.toString());
  }
}

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
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
                  child: Column(
                    children: [
                      Container(
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
                                "إنشاء حساب",
                                style: TextStyle(
                                  color: Colors.amber[600],
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25,
                                  fontStyle: FontStyle.normal,
                                ),
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.only(
                                top: 15,
                                right: 40,
                                left: 40,
                              ),
                              child: TextField(
                                cursorColor: Colors.blue,
                                controller: userNameController,
                                decoration: InputDecoration(
                                  hintStyle: TextStyle(color: Colors.black54),
                                  prefixIcon: Icon(Icons.person,color: Colors.black54,),
                                  labelText: "اسم المستخدم",
                                  hintText: "exapmle123",
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
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  filled: true,

                                  fillColor: Colors.white,
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.blue),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 40,right: 40,bottom: 30,top: 30),
                              child: TextField(
                                cursorColor: Colors.blue,
                                controller: emailController,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.mail,color: Colors.black54,),
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
                              ),
                              child: TextField(
                                cursorColor: Colors.black54,
                                obscureText: value,
                                controller: passwordController,
                                decoration: InputDecoration(
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        value = !value;
                                      });
                                    },
                                    icon: value
                                        ? Icon(Icons.remove_red_eye,color: Colors.black54,)
                                        : Icon(Icons.remove_red_eye_outlined,color: Colors.black54,),
                                  ),
                                  prefixIcon: Icon(Icons.lock,color: Colors.black54,),
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
                              padding: const EdgeInsets.only(
                                right: 40,
                                top: 30,
                                left: 40,
                                bottom: 10,
                              ),
                              child: TextField(
                                cursorColor: Colors.black54,
                                obscureText: value1,
                                controller: confirmPasswordController,
                                decoration: InputDecoration(
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        value1 = !value1;
                                      });
                                    },
                                    icon: value1
                                        ? Icon(Icons.remove_red_eye,color: Colors.black54,)
                                        : Icon(Icons.remove_red_eye_outlined,color: Colors.black54,),
                                  ),
                                  prefixIcon: Icon(Icons.check,color: Colors.black54,),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  filled: true,

                                  fillColor: Colors.white,
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.blue),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  labelText: "تأكيد كلمة المرور",
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
                              padding: const EdgeInsets.only(
                                bottom: 50,
                                top: 10,
                              ),
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
                                ontap: signup,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 10.0,
                          bottom: 5,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Divider(
                                thickness: 1,
                                color: Colors.white,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                right: 5,
                                left: 5,
                              ),
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
                              child: Divider(
                                thickness: 1,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: MyLoginContainer(
                          path: "assets/google.png",
                          heigth: 40,
                          width: 40,
                          color: Colors.white,
                          onTap: () async {
                            final user = await AuthService()
                                .signinWithGoogle();
                            if (user != null && mounted) {
                              Navigator.pushReplacementNamed(
                                context,
                                "homepage",
                              );
                            }
                          },
                        ),
                      ),
                      Row(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "لديك حساب؟ ",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, "loginpage");
                            },
                            child: Text(
                              "سجل الدخول ",
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
