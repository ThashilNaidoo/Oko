import 'package:client/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OkoButton extends StatelessWidget {
  const OkoButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        Positioned(
          bottom: 0,
          child: Container(
            width: screenWidth,
            height: 50,
            decoration: const BoxDecoration(
              color: Color(0xFF0A5C36),
              boxShadow: [
                BoxShadow(
                  color: Color.fromARGB(64, 0, 0, 0),
                  spreadRadius: 0,
                  blurRadius: 4,
                  offset: Offset(0, -4),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 10,
          left: (screenWidth - 55) / 2,
          child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomePage(),
                  ),
                );
              },
              child: Container(
                width: 55,
                height: 55,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFFFFFFF),
                  border: Border.all(
                    color: const Color(0xFF0A5C36),
                    width: 8.0,
                    strokeAlign: BorderSide.strokeAlignOutside,
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromARGB(64, 0, 0, 0),
                      spreadRadius: 5,
                      blurRadius: 5,
                      offset: Offset(0, -5),
                    ),
                  ],
                  image: const DecorationImage(
                    image: AssetImage('assets/icon.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              )),
        ),
      ],
    );
  }
}
