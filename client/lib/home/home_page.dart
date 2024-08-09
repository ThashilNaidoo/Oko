import 'package:client/utils/oko_button.dart';
import 'package:flutter/material.dart';
import 'package:client/home/crops_widget.dart';
import 'package:client/home/ellipse_painter.dart';
import 'package:client/home/news_widget.dart';
import 'package:client/home/pests_widget.dart';
import 'package:client/home/weather_widget.dart';
import 'package:tuple/tuple.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  Key _weatherKey = UniqueKey();
  Key _cropsKey = UniqueKey();
  Key _pestsKey = UniqueKey();

  Future<void> updateData() async {
    String url = 'http://10.0.2.2:3000/update?name=John%20Doe';
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        setState(() {
          _weatherKey = UniqueKey();
          _cropsKey = UniqueKey();
          _pestsKey = UniqueKey();
        });
      }
    } catch (e) {
      throw Exception('Failed to update data. Please try again.');
    }
  }

  @override
  void initState() {
    super.initState();
    updateData();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final theme = Theme.of(context);
    const double padding = 25.0;

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

    return GestureDetector(
      child: Scaffold(
        backgroundColor: const Color(0xFFF5FAF8),
        body: Stack(
          children: [
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.only(left: padding, right: padding, top: 150),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    WeatherWidget(
                      key: _weatherKey,
                    ),
                    const SizedBox(height: 30),
                    CropsWidget(
                      key: _cropsKey,
                    ),
                    const SizedBox(height: 10),
                    const NewsWidget(
                      items: news,
                    ),
                    const SizedBox(height: 30),
                    PestWidget(
                      key: _pestsKey,
                    ),
                    const SizedBox(height: 100)
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
                  location: 'Northern Cape',
                  name: 'My Farm',
                  screenWidth: screenWidth,
                  theme: theme,
                ),
              ),
            ),
            const OkoButton(),
          ],
        ),
      ),
    );
  }
}
