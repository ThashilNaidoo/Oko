import 'package:flutter/material.dart';
import 'package:client/crops/information_widget.dart';
import 'package:client/home/home_page.dart';
import 'package:client/utils/back_widget.dart';
import 'package:google_fonts/google_fonts.dart';

class CropDetailPage extends StatelessWidget {
  final String name;
  final double yield;

  const CropDetailPage({
    super.key,
    required this.name,
    required this.yield,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: 520,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/${name.toLowerCase()}.png'),
                fit: BoxFit.fill,
              ),
            ),
          ),
          InformationWidget(name: name),
          BackWidget(page: HomePage()),
        ],
      ),
    );
  }
}
