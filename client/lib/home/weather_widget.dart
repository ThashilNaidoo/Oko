import 'package:client/weather/weather_page.dart';
import 'package:flutter/material.dart';
import 'package:client/home/utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class WeatherWidget extends StatelessWidget {
  const WeatherWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    DateTime sunset = DateTime(now.year, now.month, now.day, 17, 30);
    bool day = true;
    if (now.isAfter(sunset)) {
      day = true;
    }
    String formattedDate = DateFormat('dd MMMM yyyy').format(now);

    String units = '°C';
    int high = 26;
    int low = 13;

    String description = 'Sunny conditions will subside by 4pm. This is a perfect time for watering the crops.';

    String weather = 'clear';

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
                colors: day ? gradientsDay[weather]! : gradientsNight[weather]!,
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
                )
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
                Text(
                  '23$units',
                  style: GoogleFonts.poppins(
                    fontSize: 36,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFFFAFAFA),
                  ),
                ),
                Text(
                  'H:$high$units L:$low$units',
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
                  description,
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
