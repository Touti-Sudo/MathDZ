import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:lottie/lottie.dart';
import 'package:mathdz/pages/class_details_page.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    final favoritesBox = Hive.box('favorites');
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
              SizedBox(height: 100),
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
                      padding: const EdgeInsets.fromLTRB(8, 80, 8, 8),
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
                            margin: const EdgeInsets.symmetric(
                              vertical: 6,
                              horizontal: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
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
                              leading: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.red.shade100,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                  Icons.picture_as_pdf,
                                  color: Colors.red,
                                ),
                              ),
                              title: Text(
                                pdfName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              trailing: const Icon(
                                Icons.arrow_forward_ios,
                                size: 16,
                              ),
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
