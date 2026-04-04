import 'package:flutter/material.dart';
import 'package:mathdz/components/my_home_container.dart';
import 'package:mathdz/pages/class_details_page.dart';

class HomePageContent extends StatefulWidget {
  const HomePageContent({super.key});

  @override
  State<HomePageContent> createState() => _HomePageContentState();
}

class _HomePageContentState extends State<HomePageContent> {
  int selectedIndex = 0;
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
    String mapTitleToLevelCode(String title) {
  switch (title) {
    case 'السنة الأولى من المدرسة الثانوية': return '1as';
    case 'السنة الثانية من المدرسة الثانوية': return '2as';
    case 'السنة الثالثة من المدرسة الثانوية': return '3as';
    case 'متوسط السنة الأولى': return '1cem';
    case 'متوسط السنة ثانية': return '2cem';
    case 'متوسط السنة ثالثة': return '3cem';
    case 'متوسط السنة الرابعة': return '4cem';
    default: return 'unknown';
  }
}
    return Scaffold(
      body: Stack(
        children: [
          SizedBox.expand(
            child: Image.asset(
              "assets/Background.png",
              fit: BoxFit.cover,
              filterQuality: FilterQuality.high,
            ),
          ),
          
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 100,),
                  Padding(
                    padding: const EdgeInsets.only(top: 50.0),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          MyHomeContainer(
                            height: 165,
                            heightonactive: 170,
                            width: 165,
                            widthonactive: 170,
                            imagepath: "assets/hat.png",
                            imageradius: 23,
                            text: "الثانوية",
                            description:  'سنوات التعليم الثانوي',
                            isActive: selectedIndex == 0,
                            onTap: () => setState(() => selectedIndex = 0),
                          ),
                          MyHomeContainer(
                            height: 160,
                            heightonactive: 170,
                            width: 160,
                            widthonactive: 170,
                            imagepath: "assets/bag.png",
                            imageradius: 23,
                            text: "المتوسط",
                            description: 'سنوات التعليم المتوسط',
                            isActive: selectedIndex == 1,
                            onTap: () => setState(() => selectedIndex = 1),
                          ),
                        ],
                      ),
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: selectedIndex == 0
                        ? asList.length
                        : cemList.length,
                    itemBuilder: (context, index) {
                      String title = selectedIndex == 0
                          ? asList[index]
                          : cemList[index];
                      return Card(color: Colors.amber[200],
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: ListTile(
                          title: Text(
                            title,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          trailing: Icon(Icons.arrow_forward_ios, size: 16),
                          onTap: () {
                            String levelCode = mapTitleToLevelCode(title);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ClassDetailsPage(
                                  classTitle: title,
                                  level: levelCode,
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
