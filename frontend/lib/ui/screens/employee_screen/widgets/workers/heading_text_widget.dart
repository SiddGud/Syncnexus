import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HeadingText extends StatelessWidget {
  const HeadingText({super.key, required this.text, this.size = 15});

  final String text;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: 125,
      margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: const BoxDecoration(
          color: Color.fromARGB(255, 234, 196, 72),
          borderRadius: BorderRadius.all(Radius.circular(4))),
      child: Text(
        text,
        style:
            GoogleFonts.urbanist(fontSize: size, fontWeight: FontWeight.bold),
      ),
    );
  }
}
