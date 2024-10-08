import 'package:client/home/crop_item.dart';
import 'package:flutter/material.dart';
import 'package:client/home/utils.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class Crop {
  final String name;
  final double yield;

  const Crop({
    required this.name,
    required this.yield,
  });

  factory Crop.fromJson(Map<String, dynamic> json) {
    return Crop(
      name: json['name'] as String,
      yield: (json['yield'] as num).toDouble(),
    );
  }
}

class CropsWidget extends StatefulWidget {
  const CropsWidget({
    super.key,
  });

  final bool showDelete = false;

  @override
  CropsState createState() => CropsState();
}

class CropsState extends State<CropsWidget> {
  List<Widget> items = [];
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    fetchCrops();
  }

  Future<void> fetchCrops() async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    const url = 'http://10.0.2.2:3000/crops';
    try {
      final response = await http.get(Uri.parse(url), headers: {
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        List<Crop> cropsJson = body.map((dynamic item) {
          if (item is Map<String, dynamic>) {
            return Crop.fromJson(item);
          } else {
            throw const FormatException('Invalid data format');
          }
        }).toList();

        setState(() {
          final updatedCrops = cropsJson.map((cropJson) {
            return CropItem(
              index: items.length,
              name: cropJson.name,
              yield: cropJson.yield,
              showDelete: widget.showDelete,
              onDelete: () => deleteCrop(cropJson.name),
            );
          }).toList();

          items = List<Widget>.from(updatedCrops);
          items.add(
            GestureDetector(
              onTap: () {
                showAddCropDialog();
              },
              child: const AddCropItem(),
            ),
          );
        });
      }
    } catch (e) {
      throw Exception('Failed to load crop');
    }
  }

  Future<void> addCrop(String name) async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    String url = 'http://10.0.2.2:3000/crops/$name';
    try {
      final response = await http.post(Uri.parse(url), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        fetchCrops();
      }
    } catch (e) {
      throw Exception('Failed to add crop');
    }
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

  Future<void> deleteCrop(String name) async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    String url = 'http://10.0.2.2:3000/crops/$name';
    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        fetchCrops();
      }
    } catch (e) {
      throw Exception('Failed to add crop');
    }
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
