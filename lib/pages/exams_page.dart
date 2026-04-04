import 'package:flutter/material.dart';
import 'package:mathdz/pages/class_details_page.dart';
import 'package:lottie/lottie.dart';

class ExamsPage extends StatefulWidget {
  final String level;
  final String term;
  final List<Map<String, dynamic>> pdfList;
  const ExamsPage({
    super.key,
    required this.level,
    required this.pdfList,
    required this.term,
  });

  @override
  State<ExamsPage> createState() => _ExamsPageState();
}

class _ExamsPageState extends State<ExamsPage> {
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
    return Scaffold(
      appBar: AppBar(
        title: Title(color: Colors.black, child: Text("${widget.level} exams")),
        backgroundColor: Colors.amberAccent,
      ),
      body: widget.pdfList.isEmpty
          ? Center(
              child: Column(crossAxisAlignment: CrossAxisAlignment.center,mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset('assets/sleepy.json',width: 200),
                  Text("لا توجد امتحانات حتى الآن",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 20),),
                ],
              ),
            )
          : ListView.builder(
              itemCount: widget.pdfList.length,
              itemBuilder: (context, index) {
                final pdf = widget.pdfList[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    style: ListTileStyle.list,
                    shape: Border.all(color: Colors.lightBlue, width: 2),
                    title: Text(pdf['name']),
                    trailing: const Icon(Icons.picture_as_pdf),
                    onTap: () => openPdf(pdf),
                  ),
                );
              },
            ),
    );
  }
}
