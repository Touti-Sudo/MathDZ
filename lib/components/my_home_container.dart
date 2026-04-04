import 'package:flutter/material.dart';

class MyHomeContainer extends StatefulWidget {
  final double height;
  final double width;
  final double heightonactive;
  final double widthonactive;
  final String imagepath;
  final double imageradius;
  final String text;
  final String description;
  final bool isActive;
  final VoidCallback onTap;

  const MyHomeContainer({
    super.key,
    required this.imagepath,
    required this.imageradius,
    required this.height,
    required this.width,
    required this.heightonactive,
    required this.widthonactive,
    required this.text,
    required this.description,
    required this.isActive,
    required this.onTap,
  });

  @override
  State<MyHomeContainer> createState() => _MyHomeContainerState();
}

class _MyHomeContainerState extends State<MyHomeContainer> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        width: widget.isActive ? widget.widthonactive : widget.width,
        height: widget.isActive ? widget.heightonactive : widget.height,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: widget.isActive ? const Color.fromARGB(255, 33, 54, 243) : Colors.blueAccent,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: widget.isActive
                  ? Colors.blue.withOpacity(0.9)
                  : Colors.black12,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(backgroundColor: Colors.transparent,
              backgroundImage: AssetImage(widget.imagepath),
              radius: widget.imageradius,
            ),
            const SizedBox(height: 10),
            Text(
              widget.text,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: widget.isActive ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              widget.description,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}
