import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class CircularPercentage extends StatelessWidget {
  const CircularPercentage({
    super.key,
    required this.name,
    required this.percentage,
  });

  final String name;
  final double percentage;

  @override
  Widget build(BuildContext context) {
    String threatLevel = '';
    Color progressColor;

    if (percentage < 0.5) {
      progressColor = Colors.green;
      threatLevel = 'Low';
    } else if (percentage < 0.7) {
      progressColor = Colors.orange;
      threatLevel = 'Moderate';
    } else {
      progressColor = Colors.red;
      threatLevel = 'High';
    }

    return Column(
      children: [
        CircularPercentIndicator(
          radius: 40.0,
          lineWidth: 8.0,
          percent: percentage,
          center: Text(
            threatLevel,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          progressColor: progressColor,
          circularStrokeCap: CircularStrokeCap.round,
        ),
      ],
    );
  }
}
