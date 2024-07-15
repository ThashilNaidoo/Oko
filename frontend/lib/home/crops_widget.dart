import 'package:flutter/material.dart';
import 'package:frontend/home/utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tuple/tuple.dart';

class CropsWidget extends StatefulWidget {
  const CropsWidget({
    super.key,
    required this.items,
  });

  final List<Tuple2<String, double>> items;

  @override
  CropsState createState() => CropsState();
}

class CropsState extends State<CropsWidget> {
  List<Tuple2<String, double>> items = List.empty();
  final PageController pageController = PageController();
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    items = widget.items;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeading(
          heading: 'Crops',
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 150,
          child: PageView.builder(
            controller: pageController,
            onPageChanged: (int page) {
              setState(() {
                currentPage = page;
              });
            },
            itemCount: (items.length / 3).ceil(),
            itemBuilder: (context, index) {
              int startIndex = index * 3;
              int endIndex = startIndex + 3;
              if (endIndex > items.length) {
                endIndex = items.length;
              }
              return Row(
                children: items
                    .sublist(startIndex, endIndex)
                    .map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(left: 5.0, right: 15.0),
                        child: CropItem(name: item.item1, yield: item.item2),
                      ),
                    )
                    .toList(),
              );
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate((items.length / 3).ceil(), (index) {
            return Container(
              margin:
                  const EdgeInsets.symmetric(horizontal: 4.0, vertical: 10.0),
              width: 8.0,
              height: 8.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: currentPage == index
                    ? const Color(0xFF333333)
                    : const Color(0xFF999999),
              ),
            );
          }),
        ),
      ],
    );
  }
}

class CropItem extends StatelessWidget {
  const CropItem({
    super.key,
    required this.name,
    required this.yield,
  });

  final String name;
  final double yield;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
        const SizedBox(height: 5),
        Text(
          name,
          style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          'Yield: ${yield.toString()}%',
          style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
