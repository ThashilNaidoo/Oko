import 'package:client/home/home_page.dart';
import 'package:client/pests/ellipse_painter.dart';
import 'package:client/pests/pest_item.dart';
import 'package:client/utils/back_widget.dart';
import 'package:flutter/material.dart';

class Pest {
  final String name;
  final double threat;

  const Pest({
    this.name = '',
    this.threat = 0.0,
  });

  factory Pest.fromJson(Map<String, dynamic> json) {
    return Pest(
      name: json['name'] as String,
    );
  }
}

class PestsPage extends StatefulWidget {
  const PestsPage({super.key});

  @override
  PestsPageState createState() => PestsPageState();
}

class PestsPageState extends State<PestsPage> {
  List<Pest> items = [];

  void fetchPests() {
    print('Fetching pests');
    items.add(const Pest(name: 'Rodent', threat: 0.7));
    items.add(const Pest(name: 'Bird', threat: 0.8));
    items.add(const Pest(name: 'Caterpillar', threat: 0.4));
    items.add(const Pest(name: 'Spider', threat: 0.3));
  }

  @override
  void initState() {
    fetchPests();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const double padding = 25.0;
    final double screenWidth = MediaQuery.of(context).size.width;
    final theme = Theme.of(context);

    List<Widget> pestItems = items
        .asMap()
        .entries
        .map(
          (entry) => PestItem(
            name: entry.value.name,
            threat: entry.value.threat,
          ),
        )
        .toList();

    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(left: padding, right: padding),
            child: Column(
              children: [
                const SizedBox(height: 150),
                ...pestItems,
              ],
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: CustomPaint(
              size: const Size(300, 200),
              painter: EllipsePainter(
                title: 'Pests',
                screenWidth: screenWidth,
                theme: theme,
              ),
            ),
          ),
          BackWidget(page: HomePage()),
        ],
      ),
    );
  }
}
