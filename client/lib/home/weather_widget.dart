import 'package:client/weather/weather_page.dart';
import 'package:flutter/material.dart';
import 'package:client/home/utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Weather {
  final double currTemp;
  final double maxTemp;
  final double minTemp;
  final String condition;
  final String conditionDescription;

  const Weather({this.currTemp = 0, this.maxTemp = 0, this.minTemp = 0, this.condition = '', this.conditionDescription = ''});

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
        currTemp: (json['currTemp'] as num).toDouble(),
        maxTemp: (json['maxTemp'] as num).toDouble(),
        minTemp: (json['minTemp'] as num).toDouble(),
        condition: json['condition'] as String,
        conditionDescription: json['conditionDescription'] as String);
  }
}

class WeatherWidget extends StatefulWidget {
  WeatherWidget({
    super.key,
  });

  @override
  WeatherState createState() => WeatherState();
}

class WeatherState extends State<WeatherWidget> {
  Weather weather = const Weather();

  Future<void> fetchWeather() async {
    String url = 'http://10.0.2.2:3000/weather?name=John%20Doe';
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        Map<String, dynamic> body = jsonDecode(response.body);
        Weather weather = Weather.fromJson(body);

        setState(() {
          this.weather = weather;
        });
      }
    } catch (e) {
      throw Exception('Failed to load weather');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd MMMM yyyy').format(now);
    String units = '°C';

    const gradientsDay = {
      'clear': [Color(0xFF296FAF), Color(0xFFA1E3FF)],
      'cloudy': [Color(0xFF898989), Color(0xFF296FAF)],
      'overcast': [Color(0xFF898989), Color(0xFF434343)],
    };

    const gradientsNight = {
      'clear': [Color(0xFF07081C), Color(0xFF29334E)],
      'cloudy': [Color(0xFF434343), Color(0xFF07081C)],
      'overcast': [Color(0xFF434343), Color(0xFF252525)],
    };

    Color dark = gradientsDay['clear']!.first;
    Color light = gradientsDay['clear']!.last;
    if (weather.condition.toLowerCase().contains("clear") && now.hour >= 6 && now.hour < 18) {
      dark = gradientsDay['clear']!.first;
      light = gradientsDay['clear']!.last;
    } else if (weather.condition.toLowerCase().contains("cloudy") && now.hour >= 6 && now.hour < 18) {
      dark = gradientsDay['cloudy']!.first;
      light = gradientsDay['cloudy']!.last;
    } else if (weather.condition.toLowerCase().contains("overcast") && now.hour >= 6 && now.hour < 18) {
      dark = gradientsDay['overcast']!.first;
      light = gradientsDay['overcast']!.last;
    } else if (weather.condition.toLowerCase().contains("clear")) {
      dark = gradientsNight['clear']!.first;
      light = gradientsNight['clear']!.last;
    } else if (weather.condition.toLowerCase().contains("cloudy")) {
      dark = gradientsNight['cloudy']!.first;
      light = gradientsNight['cloudy']!.last;
    } else if (weather.condition.toLowerCase().contains("overcast")) {
      dark = gradientsNight['overcast']!.first;
      light = gradientsNight['overcast']!.last;
    }

    return GestureDetector(
      onTap: () => {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const WeatherPage(),
          ),
        )
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeading(
            heading: 'Weather',
          ),
          const SizedBox(height: 10),
          Container(
            height: 190,
            width: double.infinity,
            padding: const EdgeInsets.only(left: 25, right: 25, top: 15),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [dark, light],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(15),
              boxShadow: const [
                BoxShadow(
                  color: Color(0xFF999999),
                  spreadRadius: 0,
                  blurRadius: 4,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  formattedDate,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                    color: const Color(0xFFFAFAFA),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${weather.currTemp.toStringAsFixed(0)}$units',
                        style: GoogleFonts.poppins(
                          fontSize: 36,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFFFAFAFA),
                        ),
                      ),
                    ),
                    Text(
                      weather.condition,
                      style: GoogleFonts.poppins(
                        fontSize: 36,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFFFAFAFA),
                      ),
                    ),
                  ],
                ),
                Text(
                  'H:${weather.maxTemp.toStringAsFixed(0)}$units L:${weather.minTemp.toStringAsFixed(0)}$units',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFFFAFAFA),
                  ),
                ),
                const SizedBox(height: 10),
                const Divider(
                  color: Color(0xFFFAFAFA),
                  thickness: 1.0,
                ),
                Text(
                  weather.conditionDescription,
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFFFAFAFA),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
