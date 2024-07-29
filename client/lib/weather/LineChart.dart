import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LineChartSample extends StatefulWidget {
  const LineChartSample({
    super.key,
    required this.data,
  });

  final List<double> data;

  @override
  State<LineChartSample> createState() => _LineChartSample2State();
}

class _LineChartSample2State extends State<LineChartSample> {
  List<Color> gradientColors = [
    const Color(0xFFF2F2F2),
    const Color(0xFFF2F2F2),
  ];

  bool showAvg = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 1.70,
          child: Padding(
            padding: const EdgeInsets.only(
              right: 18,
              left: 12,
              top: 24,
              bottom: 12,
            ),
            child: LineChart(
              mainData(),
            ),
          ),
        ),
      ],
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 10,
      color: Color(0xFFFAFAFA),
    );

    Widget text;
    switch (value.toInt()) {
      case 0:
        text = const Text('00', style: style);
        break;
      case 6:
        text = const Text('06', style: style);
        break;
      case 12:
        text = const Text('12', style: style);
        break;
      case 18:
        text = const Text('18', style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 10,
      color: Color(0xFFFAFAFA),
    );
    String text;
    switch (value.toInt()) {
      case 0:
        text = '0';
        break;
      case 6:
        text = '6';
        break;
      case 12:
        text = '12';
        break;
      case 18:
        text = '18';
        break;
      case 24:
        text = '24';
        break;
      case 30:
        text = '30';
        break;
      case 36:
        text = '36';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  }

  LineChartData mainData() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 6,
        verticalInterval: 6,
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: Color(0xFFF2F2F2),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: Color(0xFFF2F2F2),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 24,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xFFF2F2F2)),
      ),
      minX: 0,
      maxX: 23,
      minY: 0,
      maxY: 36,
      lineBarsData: [
        LineChartBarData(
          spots: widget.data.asMap().entries.map((entry) => FlSpot(entry.key.toDouble(), entry.value)).toList(),
          isCurved: true,
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors.map((color) => color.withOpacity(0.3)).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
