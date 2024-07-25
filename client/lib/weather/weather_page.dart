import 'package:client/home/home_page.dart';
import 'package:client/utils/back_widget.dart';
import 'package:client/weather/LineChart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Weather {
  final double currTemp;
  final double maxTemp;
  final double minTemp;
  final String condition;
  final String conditionSentence;

  final List<List<double>> sevenDay;
  final List<double> temperature;

  final double windSpeed;
  final String windDirection;

  final double precipitation;
  final double chanceOfRain;

  final double humidity;
  final double feelsLike;

  const Weather({
    this.currTemp = 0,
    this.maxTemp = 0,
    this.minTemp = 0,
    this.condition = '',
    this.conditionSentence = '',
    this.sevenDay = const [],
    this.temperature = const [],
    this.windSpeed = 0,
    this.windDirection = '',
    this.precipitation = 0,
    this.chanceOfRain = 0,
    this.humidity = 0,
    this.feelsLike = 0,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      currTemp: (json['currTemp'] as num).toDouble(),
      maxTemp: (json['maxTemp'] as num).toDouble(),
      minTemp: (json['minTemp'] as num).toDouble(),
      condition: json['condition'] as String,
      conditionSentence: json['conditionSentence'] as String,
      sevenDay: (json['sevenDay'] as List).map((e) => (e as List).map((e) => (e as num).toDouble()).toList()).toList(),
      temperature: (json['temperature'] as List).map((e) => (e as num).toDouble()).toList(),
      windSpeed: (json['windSpeed'] as num).toDouble(),
      windDirection: json['windDirection'] as String,
      precipitation: (json['precipitation'] as num).toDouble(),
      chanceOfRain: (json['chanceOfRain'] as num).toDouble(),
      humidity: (json['humidity'] as num).toDouble(),
      feelsLike: (json['feelsLike'] as num).toDouble(),
    );
  }
}

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  WeatherPageState createState() => WeatherPageState();
}

class WeatherPageState extends State<WeatherPage> {
  Weather weather = const Weather();

  Future<void> fetchWeather() async {
    const url = 'http://10.0.2.2:3000/weather?location=Johannesburg';
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
    String units = '°C';
    const double padding = 25.0;

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

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
              colors: gradientsDay['clear']!,
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            )),
          ),
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(left: padding, right: padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Column(
                    children: [
                      const SizedBox(height: 100),
                      Text(
                        'Johannesburg',
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFFFAFAFA),
                        ),
                      ),
                      Text(
                        '${weather.currTemp.toStringAsFixed(0)}$units',
                        style: GoogleFonts.poppins(
                          fontSize: 64,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFFFAFAFA),
                        ),
                      ),
                      Text(
                        weather.condition,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFFFAFAFA),
                        ),
                      ),
                      Text(
                        'H: ${weather.maxTemp.toStringAsFixed(0)}$units L: ${weather.minTemp.toStringAsFixed(0)}$units',
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFFFAFAFA),
                        ),
                      ),
                      Text(
                        weather.conditionSentence,
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFFFAFAFA),
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
                Forecast(forecast: weather.sevenDay, color: gradientsDay['clear']!.first.withOpacity(0.5)),
                TemperatureGraph(color: gradientsDay['clear']!.first.withOpacity(0.5), temperature: weather.temperature),
                WeatherItem(
                  color: gradientsDay['clear']!.first.withOpacity(0.5),
                  heading: 'Wind',
                  mainText: '${weather.windSpeed.toStringAsFixed(0)} km/h wind in a ${weather.windDirection} direction',
                  description: 'Today is a good day for wind',
                ),
                WeatherItem(
                  color: gradientsDay['clear']!.first.withOpacity(0.5),
                  heading: 'Precipitation',
                  mainText: '${weather.precipitation.toStringAsFixed(0)} mm with a ${weather.chanceOfRain.toStringAsFixed(0)}% chance of rain',
                  description: 'Today is a good day for rain',
                ),
                WeatherItem(
                  color: gradientsDay['clear']!.first.withOpacity(0.5),
                  heading: 'Humidity',
                  mainText: '${weather.humidity.toStringAsFixed(0)}% with a feels like temperature of ${weather.feelsLike.toStringAsFixed(0)}$units',
                  description: 'Today is a good day for pests',
                ),
              ],
            ),
          ),
          BackWidget(page: HomePage()),
        ],
      ),
    );
  }
}

class WeatherItem extends StatelessWidget {
  const WeatherItem({
    super.key,
    required this.color,
    required this.heading,
    required this.mainText,
    required this.description,
  });

  final Color color;
  final String heading;
  final String mainText;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          heading,
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: const Color(0xFFFAFAFA),
          ),
        ),
        const SizedBox(height: 5),
        Container(
          padding: const EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 20),
          width: double.infinity,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                mainText,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFFFAFAFA),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                description,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFFFAFAFA),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 30),
      ],
    );
  }
}

class Forecast extends StatelessWidget {
  const Forecast({
    super.key,
    required this.forecast,
    required this.color,
  });

  final List<List<double>> forecast;
  final Color color;

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    int currentWeekday = now.weekday;

    List<String> daysOfWeek = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    List<String> subsequentDays = [];
    for (int i = 0; i < 7; i++) {
      if (i == 0) {
        subsequentDays.add('Today');
        continue;
      }
      int index = (currentWeekday - 1 + i) % 7;
      subsequentDays.add(daysOfWeek[index]);
    }

    List<Widget> dayWidgets = subsequentDays
        .asMap()
        .entries
        .map(
          (entry) => Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      entry.value,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFFFAFAFA),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 20,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            forecast[entry.key][1].toStringAsFixed(0),
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFFFAFAFA),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        height: 8,
                        width: 130,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: const LinearGradient(
                            colors: [Color(0xFF73F7FF), Color(0xFFFF7A00)],
                            stops: [0.0, 1.0],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        width: 20,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            forecast[entry.key][0].toStringAsFixed(0),
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFFFAFAFA),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              if (entry.key != 6)
                const Divider(
                  color: Color(0xFAFAFAFA),
                  thickness: 1.0,
                ),
            ],
          ),
        )
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '7 day forecast',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: const Color(0xFFFAFAFA),
          ),
        ),
        const SizedBox(height: 5),
        Container(
          padding: const EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 20),
          width: double.infinity,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...dayWidgets,
            ],
          ),
        ),
        const SizedBox(height: 30),
      ],
    );
  }
}

class TemperatureGraph extends StatelessWidget {
  const TemperatureGraph({
    super.key,
    required this.color,
    required this.temperature,
  });

  final Color color;
  final List<double> temperature;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Temperature',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: const Color(0xFFFAFAFA),
          ),
        ),
        const SizedBox(height: 5),
        Container(
          padding: const EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 20),
          width: double.infinity,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Graph of temperature per hour',
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFFFAFAFA),
                ),
              ),
              LineChartSample2(),
            ],
          ),
        ),
        const SizedBox(height: 30),
      ],
    );
  }
}
