import 'package:flutter/material.dart';
import 'package:frontend/home/crops_widget.dart';
import 'package:frontend/home/ellipse_painter.dart';
import 'package:frontend/home/news_widget.dart';
import 'package:frontend/home/pests_widget.dart';
import 'package:frontend/home/weather_widget.dart';
import 'package:tuple/tuple.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final theme = Theme.of(context);
    const double padding = 25.0;
    const List<Tuple2<String, double>> crops = [
      Tuple2('Maize', 60),
      Tuple2('Maize', 60),
      Tuple2('Maize', 60),
      Tuple2('Maize', 60),
      Tuple2('Maize', 60),
    ];
    const List<Tuple2<String, int>> news = [
      Tuple2(
        '07 July Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
        1,
      ),
      Tuple2(
        '07 July Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
        2,
      ),
      Tuple2(
        '07 July Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
        5,
      ),
      Tuple2(
        '07 July Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
        7,
      ),
      Tuple2(
        '07 July Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
        10,
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF5FAF8),
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.only(
                  left: padding, right: padding, top: 150),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  WeatherWidget(screenWidth: screenWidth),
                  const SizedBox(height: 30),
                  const CropsWidget(
                    items: crops,
                  ),
                  const SizedBox(height: 10),
                  const NewsWidget(items: news),
                  const SizedBox(height: 30),
                  const PestWidget(
                    name: 'Rodents',
                    description:
                        'High alert for rodents in the area. Use  pesticide solution on your crops immediately to prevent possible loss.',
                  ),
                  const SizedBox(height: 30)
                ],
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: CustomPaint(
              size: const Size(300, 200),
              painter: EllipsePainter(
                location: 'Limpopo',
                name: 'My Farm',
                screenWidth: screenWidth,
                theme: theme,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
