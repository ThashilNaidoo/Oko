import 'package:flutter/material.dart';
import 'package:client/home/utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Tip {
  final String description;

  const Tip({
    this.description = '',
  });

  factory Tip.fromJson(Map<String, dynamic> json) {
    return Tip(
      description: json['tip'] as String,
    );
  }
}

class TipWidget extends StatefulWidget {
  const TipWidget({super.key});

  @override
  TipState createState() => TipState();
}

class TipState extends State<TipWidget> {
  Tip tip = const Tip();

  Future<void> fetchTip() async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    const url = 'http://10.0.2.2:3000/tip';
    try {
      final response = await http.get(Uri.parse(url), headers: {
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        Map<String, dynamic> body = jsonDecode(response.body);
        Tip tip = Tip.fromJson(body);

        setState(() {
          this.tip = tip;
        });
      }
    } catch (e) {
      throw Exception('Failed to load tip');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchTip();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeading(
          heading: 'Tip of the Day',
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFDAF2E7),
            borderRadius: BorderRadius.circular(15.0),
            boxShadow: const [
              BoxShadow(
                color: Color(0xFF999999),
                spreadRadius: 0,
                blurRadius: 4,
                offset: Offset(0, 4),
              )
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'OKO says:',
                  style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w700, color: const Color(0xFF333333)),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 10),
                Text(
                  tip.description,
                  style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w500, color: const Color(0xFF333333)),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
