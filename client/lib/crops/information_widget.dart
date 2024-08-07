import 'package:flutter/material.dart';
import 'package:client/crops/circular_percentage.dart';
import 'package:google_fonts/google_fonts.dart';

class InformationWidget extends StatelessWidget {
  const InformationWidget({
    super.key,
    required this.name,
    required this.yield,
    required this.weatherSuitability,
    required this.sustainability,
    required this.description,
  });

  final String name;
  final double yield;
  final double weatherSuitability;
  final double sustainability;
  final String description;

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
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(44),
                topRight: Radius.circular(44),
              ),
              boxShadow: [
                BoxShadow(
                  color: Color.fromARGB(64, 0, 0, 0),
                  spreadRadius: 0,
                  blurRadius: 4,
                  offset: Offset(0, -4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 30),
                    Text(
                      name,
                      style: GoogleFonts.poppins(
                        color: const Color(0xFF333333),
                        fontSize: 32,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      description,
                      style: GoogleFonts.poppins(
                        color: const Color(0xFF333333),
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 30),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularPercentage(
                          name: 'Yield',
                          percentage: yield,
                        ),
                        const Spacer(),
                        CircularPercentage(
                          name: 'Weather Suitability',
                          percentage: weatherSuitability,
                        ),
                        const Spacer(),
                        CircularPercentage(
                          name: 'Sustainability',
                          percentage: sustainability,
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
