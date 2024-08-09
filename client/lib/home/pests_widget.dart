import 'package:client/pests/pests_page.dart';
import 'package:flutter/material.dart';
import 'package:client/home/utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Pest {
  final String name;
  final String description;

  const Pest({
    this.name = '',
    this.description = '',
  });

  factory Pest.fromJson(Map<String, dynamic> json) {
    return Pest(
      name: json['name'] as String,
      description: json['description'] as String,
    );
  }
}

class PestWidget extends StatefulWidget {
  const PestWidget({super.key});

  @override
  PestState createState() => PestState();
}

class PestState extends State<PestWidget> {
  Pest pest = const Pest();

  Future<void> fetchPest() async {
    String url = 'http://10.0.2.2:3000/pests/featured?name=John%20Doe';
    try {
      final response = await http.get(Uri.parse(url));

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
    fetchPest();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const PestsPage(),
          ),
        )
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeading(
            heading: 'Pests',
          ),
          const SizedBox(height: 10),
          Container(
            height: 175,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color.fromARGB(255, 175, 95, 41), Color.fromARGB(255, 255, 230, 161)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15.0),
                topRight: Radius.circular(15.0),
              ),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFF999999),
                  spreadRadius: 0,
                  blurRadius: 4,
                  offset: Offset(0, 4),
                )
              ],
            ),
          ),
          Container(
            height: 80,
            decoration: const BoxDecoration(
              color: Color(0xFFF2F2F2),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(15.0),
                bottomRight: Radius.circular(15.0),
              ),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFF999999),
                  spreadRadius: 0,
                  blurRadius: 4,
                  offset: Offset(0, 4),
                )
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pest.name,
                    style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w700, color: const Color(0xFF333333)),
                  ),
                  Text(
                    pest.description,
                    style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w700, color: const Color(0xFF999999)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
