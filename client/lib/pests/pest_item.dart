import 'package:client/pests/pest_details_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PestItem extends StatefulWidget {
  const PestItem({
    super.key,
    required this.name,
  });

  final String name;

  @override
  PestItemState createState() => PestItemState();
}

class PestItemState extends State<PestItem> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PestDetailsPage(
              pestName: widget.name,
            ),
          ),
        );
      },
      child: Column(
        children: [
          Container(
            height: 130,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage('http://10.0.2.2:3000/public/images/${widget.name.toLowerCase()}_landscape.png'),
                fit: BoxFit.fill,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(3.0),
                topRight: Radius.circular(3.0),
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0xFF999999),
                  spreadRadius: 0,
                  blurRadius: 4,
                  offset: Offset(0, 4),
                )
              ],
            ),
          ),
          Container(
            height: 60,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xFFF2F2F2),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(3.0),
                bottomRight: Radius.circular(3.0),
              ),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFF999999),
                  spreadRadius: 0,
                  blurRadius: 4,
                  offset: Offset(0, 4),
                )
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 15, top: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.name,
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF333333),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }
}
