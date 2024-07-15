import 'package:english_words/english_words.dart';
import 'package:flex_seed_scheme/flex_seed_scheme.dart';
import 'package:flutter/material.dart';
import 'package:frontend/home/crops_widget.dart';
import 'package:frontend/home/ellipse_painter.dart';
import 'package:frontend/home/news_widget.dart';
import 'package:frontend/home/pests_widget.dart';
import 'package:frontend/home/weather_widget.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final ColorScheme schemeLight = SeedColorScheme.fromSeeds(
    primaryKey: const Color.fromARGB(255, 10, 92, 54),
    brightness: Brightness.light,
    variant: FlexSchemeVariant.rainbow,
  );

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Oko',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: schemeLight,
        ),
        home: const MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();

  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
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
