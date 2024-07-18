import 'package:flutter/material.dart';
import 'package:client/home/utils.dart';
import 'package:google_fonts/google_fonts.dart';

class PestWidget extends StatelessWidget {
  const PestWidget({
    super.key,
    required this.name,
    required this.description,
  });

  final String name;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeading(
          heading: 'Pests',
        ),
        const SizedBox(height: 10),
        Container(
          height: 175,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color.fromARGB(255, 175, 95, 41), Color.fromARGB(255, 255, 230, 161)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15.0),
              topRight: Radius.circular(15.0),
            ),
            boxShadow: [
              BoxShadow(
                color: Color(0xFF999999),
                spreadRadius: 0,
                blurRadius: 4,
                offset: Offset(0, 4),
              )
            ],
          ),
        ),
        Container(
          height: 80,
          decoration: const BoxDecoration(
            color: Color(0xFFF2F2F2),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(15.0),
              bottomRight: Radius.circular(15.0),
            ),
            boxShadow: [
              BoxShadow(
                color: Color(0xFF999999),
                spreadRadius: 0,
                blurRadius: 4,
                offset: Offset(0, 4),
              )
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w700, color: const Color(0xFF333333)),
                ),
                Text(
                  description,
                  style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w700, color: const Color(0xFF999999)),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
