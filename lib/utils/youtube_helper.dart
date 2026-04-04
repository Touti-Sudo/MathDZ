import 'package:flutter/material.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';


Future<Map<String, String>> getYoutubeMetadata(String url) async {
  var yt = YoutubeExplode();
  var video = await yt.videos.get(url);
  yt.close();

  return {
    "id": video.id.value,
    "title": video.title,
    "thumbnail": video.thumbnails.highResUrl,
    "channel": video.author,
  };
}


void openYoutubePlayer(BuildContext context, String videoId) {
  final controller = YoutubePlayerController(
    initialVideoId: videoId,
    flags: const YoutubePlayerFlags(autoPlay: true),
  );

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => YoutubePlayerBuilder(
        player: YoutubePlayer(controller: controller),
        builder: (context, player) {
          return Scaffold(
            appBar: AppBar(title: const Text("Watch Video")),
            body: Center(child: player),
          );
        },
      ),
    ),
  );
}
