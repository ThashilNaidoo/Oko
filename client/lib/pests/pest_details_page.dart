import 'package:client/pests/information_widget.dart';
import 'package:client/pests/pests_page.dart';
import 'package:flutter/material.dart';
import 'package:client/utils/back_widget.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class Pest {
  final String name;
  final String description;
  final double danger;

  const Pest({
    this.name = '',
    this.description = '',
    this.danger = 0,
  });

  factory Pest.fromJson(Map<String, dynamic> json) {
    return Pest(
      name: json['name'] as String,
      description: json['description'] as String,
      danger: (json['danger'] as num).toDouble() / 5,
    );
  }
}

class PestDetailsPage extends StatefulWidget {
  final String pestName;

  const PestDetailsPage({
    super.key,
    required this.pestName,
  });

  @override
  PestDetailsPageState createState() => PestDetailsPageState();
}

class PestDetailsPageState extends State<PestDetailsPage> {
  Pest pest = const Pest();

  Future<void> fetchPest(pest) async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    String url = 'http://10.0.2.2:3000/pests/$pest';
    try {
      final response = await http.get(Uri.parse(url), headers: {
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        Map<String, dynamic> body = jsonDecode(response.body);
        Pest pest = Pest.fromJson(body);

        setState(() {
          this.pest = pest;
        });
      }
    } catch (e) {
      throw Exception('Failed to load pest');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchPest(widget.pestName);
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
                image: NetworkImage('http://10.0.2.2:3000/public/images/${widget.pestName.toLowerCase()}_portrait.png'),
                fit: BoxFit.fill,
              ),
            ),
          ),
          InformationWidget(
            name: pest.name,
            description: pest.description,
            danger: pest.danger,
          ),
          const BackWidget(page: PestsPage()),
        ],
      ),
    );
  }
}
