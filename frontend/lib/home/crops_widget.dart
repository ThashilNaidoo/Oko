import 'package:flutter/material.dart';
import 'package:frontend/crops/crop_details_page.dart';
import 'package:frontend/home/utils.dart';
import 'package:google_fonts/google_fonts.dart';

class CropsWidget extends StatefulWidget {
  const CropsWidget({
    super.key,
    required this.items,
  });

  final List<Widget> items;
  final bool showDelete = false;

  @override
  CropsState createState() => CropsState();
}

class CropsState extends State<CropsWidget> {
  List<Widget> items = List.empty();
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    widget.items.add(
      GestureDetector(
        onTap: () {
          showAddCropDialog();
        },
        child: const AddCropItem(),
      ),
    );
    items = generateCropItems(widget.items);
  }

  List<Widget> generateCropItems(List<Widget> crops) {
    return crops.map((widget) {
      if (widget is CropItem) {
        return CropItem(
          index: widget.index,
          name: widget.name,
          yield: widget.yield,
          showDelete: this.widget.showDelete,
          onDelete: () => onDelete(widget.index),
        );
      } else {
        return widget;
      }
    }).toList();
  }

  void addCrop(String name) {
    setState(() {
      items.insert(
        items.length - 1,
        CropItem(
          index: items.length,
          name: name,
          yield: 60,
          showDelete: widget.showDelete,
          onDelete: () => onDelete(items.length),
        ),
      );
    });
  }

  void showAddCropDialog() {
    TextEditingController cropNameController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add new crop'),
          content: TextField(
            controller: cropNameController,
            decoration: const InputDecoration(hintText: "Enter crop name"),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Add'),
              onPressed: () {
                addCrop(cropNameController.text);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void onDelete(int index) {
    setState(() {
      items.removeAt(index);
    });
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
            onPageChanged: (int page) {
              setState(() {
                currentPage = page;
              });
            },
            scrollDirection: Axis.horizontal,
            itemCount: (items.length / 3).ceil(),
            itemBuilder: (context, index) {
              int startIndex = index * 3;
              int endIndex = startIndex + 3;
              List<Widget> cropItems = items.sublist(startIndex, endIndex > items.length ? items.length : endIndex);
              return Row(
                children: cropItems,
              );
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            (items.length / 3).ceil(),
            (index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 10.0),
                width: 8.0,
                height: 8.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: currentPage == index ? const Color(0xFF333333) : const Color(0xFF999999),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

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
            builder: (context) => CropDetailPage(
              name: widget.name,
              yield: widget.yield,
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
