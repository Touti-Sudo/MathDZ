import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';
import 'package:mathdz/components/my_button.dart';
import 'package:mathdz/pages/auth_page.dart';
import 'package:mathdz/pages/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingPage extends StatefulWidget {
  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  void saveAmount() async {
    final enteredText = amountController.text;
    if (enteredText.isNotEmpty) {
      double? amount = double.tryParse(enteredText);
      if (amount != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setDouble('user_amount', amount);
      }
    }
  }

  final TextEditingController amountController = TextEditingController();
  int currentIndex = 0;
  final PageController controller = PageController();

  final List<Map<String, dynamic>> questions = [
    {
      'animation': 'assets/go.json',
      'pic': 'assets',
      'question':
          'مرحباً، نحن سعداء جداً لأنك تستخدم MathDZ في رحلتك التعليمية، فمع MathDZ ستتعلم كيفية التعامل مع الرياضيات بأفضل طريقة ممكنة!',
      'choices': ["هيا نبدأ ! "],
    },
    {
      'animation': 'assets/searching.json',
      'question': 'كيف عثرت على تطبيقنا؟',
      'choices': ['Discord', 'Facebook', 'Github','أرسلها لي صديق'],
    },
    {
      'animation': 'assets/level.json',
      'question': 'هنا ستجد جميع المستويات من المتوسطة ​​إلى الثانوي',
      'choices': ['سأشارك هذا'],
    },
    {
      'animation': 'assets/book.json',
      'question': 'جد جميع الدروس لجميع المستويات',
      'choices': ['رائع'],
    },
    {
      'animation': 'assets/Exams.json',
      'question': 'استعد للامتحانات من خلال امتحاناتنا الخاصة',
      'choices': ['سأتدرب هنا'],
    },
        {
      'animation': 'assets/Time.json',
      'question': 'نظّم أفكارك ووقتك',
      'choices': ['سأكون مرتباً'],
    },
        {
      'animation': 'assets/20.json',
      'question':'هل أنت مستعد للحصول على العلامة الكاملة 20/20؟ قم بتسجيل الدخول وابدأ بالتألق',
      'choices': ['نعم !'],
    },
  ];
  void nextPage(String answer) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("answer_$currentIndex", answer);

    if (currentIndex < questions.length - 1) {

      setState(() {
        currentIndex++;
      });

      controller.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );

    } else {

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => AuthPage()),
      );

    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,

      body: Column(
        children: [

          SizedBox(height: 50),

          LinearProgressIndicator(color: Colors.amber[900],borderRadius: BorderRadius.circular(25),minHeight: 14,backgroundColor: Colors.grey[100],
            value: (currentIndex + 1) / questions.length,
          ),

          Expanded(
            child: PageView.builder(
              controller: controller,
              physics: NeverScrollableScrollPhysics(),
              itemCount: questions.length,
              itemBuilder: (_, index) {

                final q = questions[index];

                return Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      Lottie.asset(
                        q["animation"],repeat: false,
                        height: 200,
                      ),

                      SizedBox(height: 30),

                      Text(
                        q["question"],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: 30),

                      ...q["choices"].map<Widget>((choice) {

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),

                          child: ElevatedButton(

                            style: ElevatedButton.styleFrom(backgroundColor: Colors.amberAccent[100],
                              minimumSize: Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              
                            ),

                            onPressed: () => nextPage(choice),

                            child: Text(choice,style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold)),

                          ),
                        );

                      }).toList()

                    ],
                  ),
                );

              },
            ),
          ),
        ],
      ),
    );
  }
}