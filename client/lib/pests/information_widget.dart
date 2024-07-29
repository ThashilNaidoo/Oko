import 'package:flutter/material.dart';
import 'package:client/pests/circular_percentage.dart';
import 'package:google_fonts/google_fonts.dart';

class InformationWidget extends StatelessWidget {
  const InformationWidget({
    super.key,
    required this.name,
    required this.threat,
  });

  final String name;
  final double threat;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 420,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(44),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromARGB(64, 0, 0, 0),
                  spreadRadius: 0,
                  blurRadius: 4,
                  offset: Offset(0, -4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 30, left: 30, right: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          name,
                          style: GoogleFonts.poppins(
                            color: const Color(0xFF333333),
                            fontSize: 32,
                          ),
                        ),
                      ),
                      CircularPercentage(
                        name: 'Treat',
                        percentage: threat,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla fermentum elit vel lectus sodales suscipit. Donec leo ante, mattis sit amet commodo quis, congue nec nulla. Fusce diam odio, ultricies eget ante eget, mollis sollicitudin nibh.',
                    style: GoogleFonts.poppins(
                      color: const Color(0xFF333333),
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
