import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EllipsePainter extends CustomPainter {
  EllipsePainter({
    required this.title,
    required this.screenWidth,
    required this.theme,
  });

  final String title;
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
      160,
    );

    final path = Path()..addOval(rect);

    canvas.drawShadow(
      path,
      theme.colorScheme.shadow,
      8.0,
      false,
    );
    canvas.drawOval(rect, paint);

    final textSpanTitle = TextSpan(
      text: title,
      style: GoogleFonts.poppins(
        textStyle: TextStyle(
          color: theme.colorScheme.onPrimary,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );

    final textPainterTitle = TextPainter(
      text: textSpanTitle,
      textAlign: TextAlign.left,
      textDirection: TextDirection.ltr,
    );

    textPainterTitle.layout(minWidth: 0, maxWidth: rect.width);

    final totalTextHeight = textPainterTitle.height;
    final locationOffset = Offset(
      rect.left + (rect.width - textPainterTitle.width) / 2,
      rect.top + (rect.height - totalTextHeight) / 1.3,
    );

    textPainterTitle.paint(canvas, locationOffset);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
