import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EllipsePainter extends CustomPainter {
  EllipsePainter({
    required this.location,
    required this.name,
    required this.screenWidth,
    required this.theme,
  });

  final String location;
  final String name;
  final double screenWidth;
  final ThemeData theme;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = theme.colorScheme.primary
      ..style = PaintingStyle.fill;

    final ellipseWidth = 1.1 * screenWidth;
    final rect = Rect.fromLTWH(
      -(ellipseWidth - screenWidth) / 2,
      -65,
      ellipseWidth,
      206,
    );

    final path = Path()..addOval(rect);

    canvas.drawShadow(
      path,
      theme.colorScheme.shadow,
      8.0,
      false,
    );
    canvas.drawOval(rect, paint);

    final textSpanLocation = TextSpan(
      text: location,
      style: GoogleFonts.poppins(
          textStyle: TextStyle(
        color: theme.colorScheme.onPrimary,
        fontSize: 20,
      )),
    );

    final textSpanName = TextSpan(
      text: name,
      style: GoogleFonts.poppins(
          textStyle: TextStyle(
              color: theme.colorScheme.onPrimary,
              fontSize: 35,
              fontWeight: FontWeight.bold)),
    );

    final textPainterLocation = TextPainter(
      text: textSpanLocation,
      textAlign: TextAlign.left,
      textDirection: TextDirection.ltr,
    );

    final textPainterName = TextPainter(
      text: textSpanName,
      textAlign: TextAlign.left,
      textDirection: TextDirection.ltr,
    );

    textPainterLocation.layout(minWidth: 0, maxWidth: rect.width);
    textPainterName.layout(minWidth: 0, maxWidth: rect.width);

    final totalTextHeight = textPainterLocation.height + textPainterName.height;
    final locationOffset = Offset(
      rect.left + (rect.width - textPainterName.width) / 3,
      rect.top + (rect.height - totalTextHeight) / 1.3,
    );

    final nameOffset = Offset(
      rect.left + (rect.width - textPainterName.width) / 3,
      locationOffset.dy + textPainterLocation.height,
    );

    textPainterLocation.paint(canvas, locationOffset);
    textPainterName.paint(canvas, nameOffset);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
