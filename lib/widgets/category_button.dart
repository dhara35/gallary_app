// widgets/category_button.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoryButton extends StatelessWidget {
  final String label;

  const CategoryButton({Key? key, required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFFF5F6D), Color(0xFFFFC371)], // Pink gradient
            ),
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 2.0), // Adjust vertical padding here
            child: Center(
              child: Text(
                label,
                style: GoogleFonts.fredoka(
                  textStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 14, // Adjust font size if needed
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
