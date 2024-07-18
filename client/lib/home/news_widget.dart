import 'package:flutter/material.dart';
import 'package:client/home/utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tuple/tuple.dart';

class NewsWidget extends StatefulWidget {
  const NewsWidget({
    super.key,
    required this.items,
  });

  final List<Tuple2<String, int>> items;

  @override
  NewsState createState() => NewsState();
}

class NewsState extends State<NewsWidget> {
  List<Tuple2<String, int>> items = List.empty();
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
          heading: 'News',
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: Color(0xFFF2F2F2),
            borderRadius: BorderRadius.circular(15.0),
            boxShadow: const [
              BoxShadow(
                color: Color(0xFF999999),
                spreadRadius: 0,
                blurRadius: 4,
                offset: Offset(0, 4),
              )
            ],
          ),
          height: 230,
          child: Stack(
            children: [
              PageView.builder(
                controller: pageController,
                scrollDirection: Axis.vertical,
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
                  return Column(
                    children: items
                        .sublist(startIndex, endIndex)
                        .map(
                          (item) => Padding(
                            padding: const EdgeInsets.only(top: 10.0, left: 15.0, right: 30.0),
                            child: NewsItem(title: item.item1, relaseDate: item.item2),
                          ),
                        )
                        .toList(),
                  );
                },
              ),
              Positioned(
                right: 10,
                top: 0,
                bottom: 0,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate((items.length / 3).ceil(), (index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 4.0),
                        width: 6.0,
                        height: 6.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: currentPage == index ? const Color(0xFF333333) : const Color(0xFF999999),
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class NewsItem extends StatelessWidget {
  const NewsItem({
    super.key,
    required this.title,
    required this.relaseDate,
  });

  final String title;
  final int relaseDate;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 5),
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF333333),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: Container()),
            Text(
              '${relaseDate.toString()} day ago',
              style: GoogleFonts.poppins(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF999999),
              ),
            ),
          ],
        ),
        const Divider(
          color: Colors.black,
          thickness: 1.0,
        ),
      ],
    );
  }
}
