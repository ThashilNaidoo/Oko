import 'package:client/crops/crop_details_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CropItem extends StatefulWidget {
  CropItem({
    super.key,
    required this.index,
    required this.name,
    required this.yield,
    required this.showDelete,
    required this.onDelete,
  });

  final int index;
  final String name;
  final double yield;
  bool showDelete;
  VoidCallback onDelete;

  @override
  CropItemState createState() => CropItemState();
}

class CropItemState extends State<CropItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CropDetailsPage(
              cropName: widget.name,
            ),
          ),
        );
      },
      onLongPress: () {
        setState(() {
          widget.showDelete = true;
        });
      },
      child: Padding(
        padding: const EdgeInsets.only(
          left: 5.0,
          right: 15.0,
          top: 5.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.amber,
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
                if (widget.showDelete)
                  Positioned(
                    top: -5,
                    right: -5,
                    child: GestureDetector(
                      onTap: () {
                        widget.onDelete();
                      },
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 5),
            Text(
              widget.name,
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              'Yield: ${widget.yield.toString()}%',
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AddCropItem extends StatelessWidget {
  const AddCropItem({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 5.0,
        right: 15.0,
        top: 5.0,
      ),
      child: SizedBox(
        width: 100,
        height: 100,
        child: Column(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: const ShapeDecoration(
                shape: CircleBorder(
                    side: BorderSide(
                  color: Color(0xFF6B9984),
                  width: 2,
                )),
                color: Colors.transparent,
              ),
              child: Center(
                child: Text(
                  '+',
                  style: GoogleFonts.poppins(
                    color: const Color(0xFF0A5C36),
                    fontSize: 25,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            ),
            Center(
              child: Text(
                'Add new crops',
                style: GoogleFonts.poppins(
                  color: const Color(0xFF0A5C36),
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
