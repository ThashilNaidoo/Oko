import 'package:client/home/home_page.dart';
import 'package:client/utils/ellipse_painter.dart';
import 'package:client/pests/pest_item.dart';
import 'package:client/utils/back_widget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class Pest {
  final String name;
  const Pest({
    this.name = '',
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
  List<PestItem> items = [];

  Future<void> fetchPests() async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    String url = 'http://10.0.2.2:3000/pests';
    try {
      final response = await http.get(Uri.parse(url), headers: {
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        List<PestItem> pestsJson = body.map((dynamic item) {
          if (item is Map<String, dynamic>) {
            Pest pest = Pest.fromJson(item);
            return PestItem(name: pest.name);
          } else {
            throw const FormatException('Invalid data format');
          }
        }).toList();

        setState(() {
          items = pestsJson;
        });
      }
    } catch (e) {
      throw Exception('Failed to load pest');
    }
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

    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(left: padding, right: padding),
            child: Column(
              children: [
                const SizedBox(height: 150),
                ...items,
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
