import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mathdz/components/discord_tile.dart';
import 'package:mathdz/pages/favorite_page.dart';
import 'package:mathdz/pages/home_page_content.dart';
import 'package:mathdz/pages/profile_page.dart';
import 'package:mathdz/pages/program_page.dart';
import 'package:mathdz/services/profile_avatare.dart';
import 'package:share_plus/share_plus.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedNavIndex = 0;
  void navigation(int index) {
    setState(() {
      selectedNavIndex = index;
    });
  }

  final user = FirebaseAuth.instance.currentUser;

  void shareApp() {
    Share.share(
      'اطلع على MathDZ 📘\n\n'
      'تطبيق مفتوح المصدر لتعليم الرياضيات لجميع المستويات\n\n'
      'قم بالتنزيل من هنا:\n'
      'https://github.com/Touti-Sudo/MathDZ',
    );
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final List<Widget> pages = [
    HomePageContent(),
    ProgramPage(),
    FavoritePage(),
    ProfilePage(),
  ];
  List<String> cemList = [
    'متوسط السنة الأولى',
    'متوسط السنة ثانية',
    "متوسط السنة ثالثة",
    "متوسط السنة الرابعة",
  ];
  List<String> asList = [
    'السنة الأولى من المدرسة الثانوية',
    "السنة الثانية من المدرسة الثانوية",
    'السنة الثالثة من المدرسة الثانوية',
  ];
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        key: _scaffoldKey,
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedIconTheme: IconThemeData(color: Colors.amber[600]),
          selectedLabelStyle: TextStyle(color: Colors.amber[600]),
          selectedItemColor: Colors.amber[600],
          currentIndex: selectedNavIndex,
          onTap: navigation,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_filled),
              label: "الصفحة الرئيسية",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month),
              label: "البرنامج",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: "المفضلة",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: "ملفي الشخصي",
            ),
          ],
        ),
        endDrawer: Directionality(textDirection: TextDirection.rtl,
          child: Drawer(
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    gradient: LinearGradient(
                      colors: [
                        Colors.blue.withAlpha(200),
                        Colors.blue.withAlpha(10),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Image.asset("assets/drawerBackground.png", height: 200),
                ),
                Expanded(
                  child: ListView(
                    children: [
                      ListTile(
                        leading: Icon(Icons.home_filled),
                        title: Text("الصفحة الرئيسية"),
                        iconColor: Colors.amber,
                        onTap: () {
                          Navigator.pop(context);
                          setState(() {
                            selectedNavIndex = 0;
                          });
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.calendar_month),
                        title: Text("البرنامج"),
                        iconColor: Colors.amber,
                        onTap: () {
                          Navigator.pop(context);
                          setState(() {
                            selectedNavIndex = 1;
                          });
                        },
                      ),
          
                      ListTile(
                        leading: Icon(Icons.favorite),
                        title: Text("المفضلة"),
                        iconColor: Colors.amber,
                        onTap: () {
                          Navigator.pop(context);
                          setState(() {
                            selectedNavIndex = 2;
                          });
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.person),
                        title: Text("ملفي الشخصي"),
                        iconColor: Colors.amber,
                        onTap: () {
                          Navigator.pop(context);
                          setState(() {
                            selectedNavIndex = 3;
                          });
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.logout),
                        title: Text("تسجيل الخروج"),
                        iconColor: Colors.amber,
                        onTap: () async {
                          await FirebaseAuth.instance.signOut();
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            'loginpage',
                            (route) => false,
                          );
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: AnimatedDiscordTile(
                    height: 40,
                    width: double.infinity,
                    radius: 10,
                    color: Colors.blue[900] ?? Colors.blueAccent,
                    icon: Icons.discord,
                    text: " ! Join our server Now ",
                  ),
                ),
              ],
            ),
          ),
        ),
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                transitionBuilder: (child, animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0.1, 0),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    ),
                  );
                },
                child: pages[selectedNavIndex],
              ),
            ),
            Image.asset("assets/App-footer1.png"),
            Positioned(
              top: 40,
              left: 20,
              child: IconButton(
                color: const Color.fromARGB(255, 33, 37, 243),
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(
                    Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
                icon: Icon(Icons.menu, size: 30),
                onPressed: () => _scaffoldKey.currentState!.openEndDrawer(),
              ),
            ),
            Positioned(
              top: 40,
              right: 20,
              child: Padding(
                padding: const EdgeInsets.only(right: 10, top: 8, bottom: 8),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      width: 50,
                      height: 50,
                      decoration: const BoxDecoration(shape: BoxShape.circle),
                      child: ProfileAvatar(
                        imagePath: "assets/user.png",
                        imageUrl: user?.photoURL,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        right: 10,
                        top: 8,
                        bottom: 8,
                      ),
                      child: Text(
                        user?.displayName ?? "anonymous",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
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
