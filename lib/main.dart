import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:hive/hive.dart';
import 'package:mathdz/pages/auth_page.dart';
import 'package:mathdz/pages/favorite_page.dart';
import 'package:mathdz/pages/help_and_support.dart';
import 'package:mathdz/pages/home_page.dart';
import 'package:mathdz/pages/login_page.dart';
import 'package:mathdz/pages/on_boarding_page.dart';
import 'package:mathdz/pages/privacy_policy.dart';
import 'package:mathdz/pages/profile_settings.dart';
import 'package:mathdz/pages/program_page.dart';
import 'package:mathdz/pages/register_page.dart';
import 'package:mathdz/utils/shared_pref.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await Hive.initFlutter();
  await Hive.openBox('mybox');
  await Hive.openBox('favorites');
  await Hive.openBox('cache');
  bool firstTime = await isFirstTime();
  await Hive.box('favorites').clear();
  runApp(MyApp(firstTime: firstTime));
}

class MyApp extends StatelessWidget {
    final bool firstTime;
  const MyApp({super.key, required this.firstTime});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: firstTime ? OnboardingPage() : Directionality(textDirection: TextDirection.rtl, child: AuthPage()),
      routes: {
        'homepage': (context) =>
            Directionality(textDirection: TextDirection.ltr, child: HomePage()),
        'loginpage': (context) => Directionality(
          textDirection: TextDirection.rtl,
          child: LoginPage(),
        ),
        'registerpage': (context) => Directionality(
          textDirection: TextDirection.rtl,
          child: RegisterPage(),
        ),
        'favoritepage': (context) => Directionality(
          textDirection: TextDirection.rtl,
          child: FavoritePage(),
        ),
        'programpage': (context) => Directionality(
          textDirection: TextDirection.rtl,
          child: ProgramPage(),
        ),

        'privacypolicy': (context) => Directionality(textDirection: TextDirection.rtl,child: PrivacyPolicy()),
        'helpandsupport': (context) => Directionality(
          textDirection: TextDirection.rtl,
          child: HelpAndSupport(),
        ),
      },
    );
  }
}
