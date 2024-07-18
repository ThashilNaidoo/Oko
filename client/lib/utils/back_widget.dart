import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BackWidget extends StatelessWidget {
  final Widget page;

  const BackWidget({
    super.key,
    required this.page,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 52,
      left: 24,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => page,
            ),
          );
        },
        child: Container(
          width: 40,
          height: 40,
          decoration: const ShapeDecoration(
            shape: CircleBorder(),
            color: Colors.white,
            shadows: [
              BoxShadow(
                color: Color.fromARGB(64, 0, 0, 0),
                spreadRadius: 0,
                blurRadius: 10,
                offset: Offset(0, 0),
              ),
            ],
          ),
          child: Center(
            child: Text(
              '<',
              style: GoogleFonts.poppins(
                  color: const Color(0xFF0A5C36),
                  fontSize: 30,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ),
    );
  }
}
