import 'package:flutter/material.dart';
import 'package:client/crops/information_widget.dart';
import 'package:client/home/home_page.dart';
import 'package:client/utils/back_widget.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Crop {
  final double yield;
  final double weatherSuitability;
  final double sustainability;
  final String description;

  const Crop({
    this.yield = 0,
    this.weatherSuitability = 0,
    this.sustainability = 0,
    this.description = '',
  });

  factory Crop.fromJson(Map<String, dynamic> json) {
    return Crop(
      yield: (json['yield'] as num).toDouble(),
      weatherSuitability: (json['weatherSuitability'] as num).toDouble(),
      sustainability: (json['sustainability'] as num).toDouble(),
      description: json['description'] as String,
    );
  }
}

class CropDetailsPage extends StatefulWidget {
  const CropDetailsPage({
    super.key,
    required this.cropName,
  });

  final String cropName;

  @override
  CropDetailsPageState createState() => CropDetailsPageState();
}

class CropDetailsPageState extends State<CropDetailsPage> {
  Crop crop = const Crop();

  Future<void> fetchCropDetails(cropName) async {
    String url = 'http://10.0.2.2:3000/crops/$cropName?name=John%20Doe';
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        Map<String, dynamic> body = jsonDecode(response.body);
        print(response.body);
        Crop crop = Crop.fromJson(body);

        setState(() {
          this.crop = crop;
        });
      } else {
        print(response.body);
      }
    } catch (e) {
      print(e.toString());
      throw Exception('Failed to load crop details');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchCropDetails(widget.cropName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: 520,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/${widget.cropName.toLowerCase()}.png'),
                fit: BoxFit.fill,
              ),
            ),
          ),
          InformationWidget(
            name: widget.cropName,
            yield: crop.yield / 100,
            weatherSuitability: crop.weatherSuitability / 100,
            sustainability: crop.sustainability / 100,
            description: crop.description,
          ),
          BackWidget(page: HomePage()),
        ],
      ),
    );
  }
}
