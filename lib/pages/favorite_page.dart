import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:lottie/lottie.dart';
import 'package:mathdz/pages/class_details_page.dart';

class FavoritePage extends StatelessWidget {
  final Box favoritesBox = Hive.box('favorites');
  FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
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
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 100,),
              Expanded(
                child: ValueListenableBuilder(
                  valueListenable: favoritesBox.listenable(),
                  builder: (context, Box box, _) {
                    final favorites = box.toMap().entries.toList();

                    if (favorites.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Lottie.asset("assets/nothing_yet.json"),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  "لا توجد مفضلات حتى الآن ❤️",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: favorites.length,
                      itemBuilder: (context, index) {
                        final entry = favorites[index];
                        final key = entry.key;
                        final pdfData = Map<String, dynamic>.from(entry.value);
                        final pdfUrl = pdfData['url'] as String?;
                        if (pdfUrl == null) {
                          return const SizedBox();
                        }

                        final pdfName = pdfData['name'] ?? 'Unknown';

                        return Slidable(
                          key: Key(key.toString()),
                          endActionPane: ActionPane(
                            motion: const ScrollMotion(),
                            children: [
                              SlidableAction(
                                onPressed: (_) {
                                  favoritesBox.delete(key);
                                },
                                icon: Icons.delete,
                                backgroundColor: Colors.red.shade300,
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ],
                          ),
                          child: Container(
                            color: Colors.white,
                            child: ListTile(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PdfViewerPage(
                                      pdf: pdfData,
                                      pdfUrl: pdfUrl,
                                    ),
                                  ),
                                );
                              },
                              leading: const Icon(Icons.picture_as_pdf),
                              title: Text(pdfName),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
