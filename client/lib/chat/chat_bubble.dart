import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({
    super.key,
    required this.message,
    required this.axisAlignment,
    required this.color,
    required this.textAlign,
    required this.margin,
  });

  final String message;
  final MainAxisAlignment axisAlignment;
  final Color color;
  final TextAlign textAlign;
  final EdgeInsetsGeometry margin;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: axisAlignment,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0xFF999999),
                      spreadRadius: 0,
                      blurRadius: 4,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
                margin: margin,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    message,
                    style: GoogleFonts.poppins(color: const Color(0xFF333333)),
                    textAlign: textAlign,
                    softWrap: true,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
