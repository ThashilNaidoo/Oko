import 'package:client/pests/information_widget.dart';
import 'package:client/pests/pests_page.dart';
import 'package:flutter/material.dart';
import 'package:client/utils/back_widget.dart';

class PestDetailsPage extends StatelessWidget {
  final String name;
  final double threat;

  const PestDetailsPage({
    super.key,
    required this.name,
    required this.threat,
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
                image: AssetImage('assets/pests/${name.toLowerCase()}.webp'),
                fit: BoxFit.fill,
              ),
            ),
          ),
          InformationWidget(
            name: name,
            threat: threat,
          ),
          const BackWidget(page: PestsPage()),
        ],
      ),
    );
  }
}
