import 'dart:convert';

import 'package:client/auth/login_page.dart';
import 'package:client/home/tip_widget.dart';
import 'package:client/utils/oko_button.dart';
import 'package:client/utils/signout_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:client/home/crops_widget.dart';
import 'package:client/home/ellipse_painter.dart';
import 'package:client/home/pests_widget.dart';
import 'package:client/home/weather_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserData {
  final String location;
  final String farmName;

  const UserData({
    this.location = '',
    this.farmName = '',
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      farmName: json['farmName'] as String,
      location: json['location'] as String,
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  Key _weatherKey = UniqueKey();
  Key _cropsKey = UniqueKey();
  Key _pestsKey = UniqueKey();
  UserData userData = const UserData();

  Future<void> updateData() async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    String url = 'http://10.0.2.2:3000/update';
    try {
      final response = await http.get(Uri.parse(url), headers: {
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        Map<String, dynamic> body = jsonDecode(response.body);
        UserData userData = UserData.fromJson(body);

        setState(() {
          _weatherKey = UniqueKey();
          _cropsKey = UniqueKey();
          _pestsKey = UniqueKey();
          this.userData = userData;
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
                    const TipWidget(),
                    const SizedBox(height: 30),
                    PestWidget(
                      key: _pestsKey,
                    ),
                    const SizedBox(height: 50),
                    Center(
                      child: GestureDetector(
                        onTap: () async {
                          await FirebaseAuth.instance.signOut();
                          Future.delayed(const Duration(seconds: 3), () {
                            Navigator.of(context, rootNavigator: true).push(
                              MaterialPageRoute(
                                builder: (_) => const LoginPage(),
                              ),
                            );
                          });
                        },
                        child: Text(
                          'Sign out',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF0A5C36),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 100),
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
                  location: userData.location,
                  name: userData.farmName,
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
