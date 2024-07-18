import 'package:flutter/material.dart';
import 'package:client/crops/circular_percentage.dart';
import 'package:google_fonts/google_fonts.dart';

class InformationWidget extends StatelessWidget {
  const InformationWidget({
    super.key,
    required this.name,
  });

  final String name;

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
                  Text(
                    name,
                    style: GoogleFonts.poppins(
                      color: const Color(0xFF333333),
                      fontSize: 32,
                    ),
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
                  const Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularPercentage(
                        name: 'Yield',
                        percentage: 0.7,
                      ),
                      Spacer(),
                      CircularPercentage(
                        name: 'Weather Suitability',
                        percentage: 0.62,
                      ),
                      Spacer(),
                      CircularPercentage(
                        name: 'Sustainability',
                        percentage: 0.34,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
