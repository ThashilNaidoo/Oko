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
    Color progressColor;
    if (percentage < 0.5) {
      progressColor = Colors.red;
    } else if (percentage < 0.7) {
      progressColor = Colors.orange;
    } else {
      progressColor = Colors.green;
    }

    return Column(
      children: [
        CircularPercentIndicator(
          radius: 50.0,
          lineWidth: 10.0,
          percent: percentage,
          center: Text(
            '${percentage * 100}%',
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          progressColor: progressColor,
          circularStrokeCap: CircularStrokeCap.round,
        ),
        const SizedBox(height: 10),
        Center(
          child: Text(
            name,
            style: GoogleFonts.poppins(
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }
}
