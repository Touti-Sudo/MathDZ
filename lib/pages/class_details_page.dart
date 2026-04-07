import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:http/http.dart' as http;
import 'package:mathdz/components/my_home_container.dart';
import 'package:mathdz/components/video_card.dart';
import 'package:mathdz/pages/exams_page.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class ClassDetailsPage extends StatefulWidget {
  final String classTitle;
  final String level;
  const ClassDetailsPage({
    Key? key,
    required this.classTitle,
    required this.level,
  }) : super(key: key);

  @override
  State<ClassDetailsPage> createState() => _ClassDetailsPageState();
}

class _ClassDetailsPageState extends State<ClassDetailsPage> {
  List<Map<String, dynamic>> term1List = [];
  List<Map<String, dynamic>> term2List = [];
  List<Map<String, dynamic>> term3List = [];
  List<Map<String, dynamic>> pdfList = [];
  List<Map<String, dynamic>> videoList = [];
  int selectedIndex = 0;

  final _cacheBox = Hive.box('cache');

  @override
  void initState() {
    super.initState();
    loadContent(widget.level);
  }

  void loadContent(String level) async {
    final cached = _cacheBox.get(level);

    if (cached != null) {
      setState(() {
        pdfList = (cached['pdf'] as List)
            .map((e) => Map<String, dynamic>.from(e))
            .toList();

        videoList = (cached['video'] as List)
            .map((e) => Map<String, dynamic>.from(e))
            .toList();

        term1List = (cached['term1'] as List)
            .map((e) => Map<String, dynamic>.from(e))
            .toList();

        term2List = (cached['term2'] as List)
            .map((e) => Map<String, dynamic>.from(e))
            .toList();

        term3List = (cached['term3'] as List)
            .map((e) => Map<String, dynamic>.from(e))
            .toList();
      });
    }

    fetchContent(level);
  }

  Future<void> fetchContent(String level) async {
    final jsonUrl =
        "https://raw.githubusercontent.com/Touti-Sudo/MathDZ/refs/heads/main/$level.json";

    try {
      final response = await http.get(Uri.parse(jsonUrl));
      if (response.statusCode == 200 && response.body.isNotEmpty) {
        final List<dynamic> data = jsonDecode(response.body);

        final pdfs = data
            .where((e) => e['type'] == 'pdf')
            .map<Map<String, dynamic>>((e) => Map<String, dynamic>.from(e))
            .toList();

        final videos = data
            .where((e) => e['type'] == 'video')
            .map<Map<String, dynamic>>((e) => Map<String, dynamic>.from(e))
            .toList();
        final term1 = data
            .where((e) => e['term'] == '1')
            .map<Map<String, dynamic>>((e) => Map<String, dynamic>.from(e))
            .toList();
        final term2 = data
            .where((e) => e['term'] == '2')
            .map<Map<String, dynamic>>((e) => Map<String, dynamic>.from(e))
            .toList();
        final term3 = data
            .where((e) => e['term'] == '3')
            .map<Map<String, dynamic>>((e) => Map<String, dynamic>.from(e))
            .toList();

        _cacheBox.put(level, {
          'pdf': pdfs,
          'video': videos,
          'term1': term1,
          'term2': term2,
          'term3': term3,
        });

        setState(() {
          pdfList = pdfs;
          videoList = videos;
          term1List = term1;
          term2List = term2;
          term3List = term3;
        });
      }
    } catch (e) {
      debugPrint('Error fetching content: $e');
    }
  }

  void openPdf(Map<String, dynamic> pdf) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PdfViewerPage(pdfUrl: pdf['url'], pdf: pdf),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final termsData = [
      {'name': '1', 'list': term1List},
      {'name': '2', 'list': term2List},
      {'name': '3', 'list': term3List},
    ];
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.classTitle),
          backgroundColor: Colors.amberAccent,
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MyHomeContainer(
                    imagepath: "assets/exam.png",
                    imageradius: 23,
                    height: 160,
                    heightonactive: 170,
                    width: 160,
                    widthonactive: 170,
                    text: "مواضيعنا",
                    description: "الامتحانات والتمارين",
                    isActive: selectedIndex == 0,
                    onTap: () => setState(() => selectedIndex = 0),
                  ),
                  MyHomeContainer(
                    imagepath: "assets/video.jpg",
                    imageradius: 23,
                    height: 160,
                    heightonactive: 170,
                    width: 160,
                    widthonactive: 170,
                    text: "فيديوهاتنا",
                    description: "فيديوهات دروس الرياضيات",
                    isActive: selectedIndex == 1,
                    onTap: () => setState(() => selectedIndex = 1),
                  ),
                ],
              ),
            ),
            Expanded(
              child: selectedIndex == 0
                  ? pdfList.isEmpty
                        ? const Center(child: CircularProgressIndicator())
                        : ListView.builder(
                            itemCount: termsData.length,
                            itemBuilder: (context, index) {
                              final term = termsData[index]['name'] as String;
                              final list =
                                  termsData[index]['list']
                                      as List<Map<String, dynamic>>;

                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ListTile(
                                  shape: Border.all(
                                    color: Colors.lightBlue,
                                    width: 2,
                                  ),
                                  title: Text("Term $term"),
                                  trailing: const Icon(Icons.picture_as_pdf),
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ExamsPage(
                                        level: widget.level,
                                        pdfList: list,
                                        term: term,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          )
                  : videoList.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: videoList.length,
                      addAutomaticKeepAlives: true,
                      cacheExtent: 400,
                      itemBuilder: (context, index) {
                        final video = videoList[index];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: VideoCard(
                            key: ValueKey(video['url']),
                            url: video['url'],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class PdfViewerPage extends StatelessWidget {
  final Map<String, dynamic> pdf;
  final _mybox = Hive.box('favorites');
  final String pdfUrl;
  PdfViewerPage({super.key, required this.pdfUrl, required this.pdf});
  @override
  Widget build(BuildContext context) {
    return Directionality(textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(pdf['name']),
          actions: [
            ValueListenableBuilder(
              valueListenable: _mybox.listenable(),
              builder: (context, box, _) {
                final isFav = box.containsKey(pdfUrl);
                return IconButton(
                  icon: Icon(
                    isFav ? Icons.favorite : Icons.favorite_border,
                    color: Colors.red,
                  ),
                  onPressed: () async {
                    if (isFav) {
                      await box.delete(pdfUrl);
                    } else {
                      await box.put(pdfUrl, {
                        'url': pdf['url'],
                        'name': pdf['name'],
                      });
                    }
                  },
                );
              },
            ),
          ],
        ),
        body: SfPdfViewer.network(pdfUrl),
      ),
    );
  }
}
