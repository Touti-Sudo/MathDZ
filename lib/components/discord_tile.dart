import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AnimatedDiscordTile extends StatefulWidget {
  final double height;
  final double width;
  final Color color;
  final double radius;
  final IconData icon;
  final String text;

  const AnimatedDiscordTile({
    super.key,
    required this.height,
    required this.width,
    required this.radius,
    required this.color,
    required this.icon,
    required this.text,
  });

  @override
  _AnimatedDiscordTileState createState() => _AnimatedDiscordTileState();
}

class _AnimatedDiscordTileState extends State<AnimatedDiscordTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();


    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
      void openLink(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          padding: EdgeInsets.all(4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.radius),
            gradient: SweepGradient(
              colors: [
                Color(0xFF001AFF),
                Color.fromARGB(255, 0, 38, 255),
                Color(0xFF0066FF),
                Color.fromARGB(255, 0, 60, 255),
                Color.fromARGB(255, 0, 60, 255),
                Color.fromARGB(255, 0, 102, 255),
                Color.fromARGB(255, 0, 102, 255),
                Color.fromARGB(255, 0, 110, 255),
              ],
              transform: GradientRotation(_controller.value * 2 * 3.1415),
            ),
          ),

          child: GestureDetector(
            onTap: () {
              openLink("https://discord.gg/4aWN3cNjMh");
            },
            child: Container(
              height: widget.height,
              width: widget.width,
              decoration: BoxDecoration(
                color: widget.color,
                borderRadius: BorderRadius.circular(widget.radius - 4),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,

                children: [
                  SizedBox(width: 50),

                  Expanded(
                    child: Text(
                      widget.text,
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                  SizedBox(width: 10),
                  Icon(
                    widget.icon,
                    color: Colors.white,
                    size: widget.height * 0.5,
                  ),
                  SizedBox(width: 10),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
