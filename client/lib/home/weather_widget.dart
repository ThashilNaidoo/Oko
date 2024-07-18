import 'package:flutter/material.dart';
import 'package:client/home/utils.dart';

class WeatherWidget extends StatelessWidget {
  const WeatherWidget({
    super.key,
    required this.screenWidth,
  });

  final double screenWidth;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeading(
          heading: 'Weather',
        ),
        const SizedBox(height: 10),
        Container(
          width: screenWidth,
          height: 230,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF296FAF), Color(0xFFA1E3FF)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(15),
            boxShadow: const [
              BoxShadow(
                color: Color(0xFF999999),
                spreadRadius: 0,
                blurRadius: 4,
                offset: Offset(0, 4),
              )
            ],
          ),
        ),
      ],
    );
  }
}
