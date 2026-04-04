import 'package:flutter/material.dart';
import 'package:mathdz/utils/youtube_helper.dart';

class VideoCard extends StatefulWidget {
  final String url;
  const VideoCard({super.key, required this.url});

  @override
  State<VideoCard> createState() => _VideoCardState();
}

class _VideoCardState extends State<VideoCard> {
  String? title;
  String? thumbnail;
  String? channel;
  String? videoId;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final data = await getYoutubeMetadata(widget.url);
     if (!mounted) return;
    setState(() {
      title = data["title"];
      channel = data["channel"];
      thumbnail = data["thumbnail"];
      videoId = data["id"];
    });
  }

@override
Widget build(BuildContext context) {
  return GestureDetector(
    onTap: () {
      if (videoId != null) {
        openYoutubePlayer(context, videoId!);
      }
    },
    child: Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          thumbnail != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(thumbnail!, fit: BoxFit.cover),
                )
              : Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Icon(Icons.play_circle_fill,
                        size: 50, color: Colors.white70),
                  ),
                ),


          Padding(
            padding: const EdgeInsets.all(8.0),
            child: title != null
                ? Text(
                    title!,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : const LinearProgressIndicator(),
          ),


          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: channel != null
                ? Text(
                    channel!,
                    style: const TextStyle(color: Colors.grey),
                  )
                : Container(), 
          ),
        ],
      ),
    ),
  );
}
}