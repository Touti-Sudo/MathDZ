import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpAndSupport extends StatelessWidget {
  const HelpAndSupport({super.key});

  @override
  Widget build(BuildContext context) {
    Future<void> openUrl(String url) async {
      final uri = Uri.parse(url);
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        throw 'Could not launch $url';
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amberAccent,
        title: Row(children: [Text("المساعدة والدعم")]),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15),
              child: Text(
                "FAQ",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ExpansionTile(
                  leading: Icon(Icons.question_answer),
                  iconColor: Colors.amberAccent,
                  title: Text("كيف أقوم بإنشاء حساب؟"),
                  children: const [
                    Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Text(
                        "انتقل إلى صفحة التسجيل، وأدخل بريدك الإلكتروني وكلمة المرور، وستكون قد دخلت!",
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ExpansionTile(
                  leading: Icon(Icons.question_answer),
                  iconColor: Colors.amberAccent,
                  title: Text("لقد نسيت كلمة المرور الخاصة بي، ماذا أفعل؟"),
                  children: const [
                    Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Text('انقر على زر "نسيت كلمة المرور" واتبع الخطوات'),
                    ),
                  ],
                ),
              ),
            ),
        
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ExpansionTile(
                  leading: Icon(Icons.question_answer),
                  iconColor: Colors.amberAccent,
                  title: Text("لماذا لا يتم تحميل التطبيق؟"),
                  children: [
                    Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Text(
                        "تحقق من اتصالك بالإنترنت، فالتطبيق يتطلب اتصالاً بالإنترنت ليعمل ويتم تحميله بشكل صحيح.",
                      ),
                    ),
                  ],
                ),
              ),
            ),
        
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ExpansionTile(
                  leading: Icon(Icons.question_answer),
                  iconColor: Colors.amberAccent,
                  title: Text("هل برنامج MathDZ مجاني؟"),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                          const Text(
                            "MathDZ برنامج مفتوح المصدر وموجود على موقع GitHub: ",
                          ),
                          InkWell(
                            onTap: () =>
                                openUrl("https://github.com/Touti-Sudo/MathDZ"),
                            child: const Text(
                              "https://github.com/Touti-Sudo/MathDZ",
                              style: TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ExpansionTile(
                  leading: Icon(Icons.question_answer),
                  iconColor: Colors.amberAccent,
                  title: Text("كيف يمكنني الاتصال بالدعم الفني؟"),
                  children: [
                    Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Text(
                        "يمكنكم التواصل معي عبر بريدي الإلكتروني anestouta02@gmail.com",
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
