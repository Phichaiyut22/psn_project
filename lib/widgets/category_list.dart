// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:budget_tracker_application_2/utils/icons_list.dart';

class CategoryList extends StatefulWidget {
  const CategoryList({super.key, required this.onChange});
  final ValueChanged<String?> onChange;

  @override
  State<CategoryList> createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  String currenCategory = "All";
  List<Map<String, dynamic>> categorylist = [];
  final scrollController = ScrollController();
  var appIcons = AppIcons();

  var addCat = {
    "name": "All",
    "icon": FontAwesomeIcons.cartPlus,
  };

  @override
  void initState() {
    super.initState();
    setState(() {
      categorylist = appIcons.homeExpensesCategories;
      categorylist.insert(0, addCat);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        height: 45.0,
        child: ListView.builder(
          controller: scrollController,
          itemCount: categorylist.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            var data = categorylist[index];
            return GestureDetector(
              onTap: () {
                setState(() {
                  currenCategory = data['name'];
                  widget.onChange(data['name']);
                });
              },
              child: Container(
                margin: EdgeInsets.all(6),
                padding: EdgeInsets.symmetric(
                  horizontal: 8.0,
                ),
                decoration: BoxDecoration(
                  color: currenCategory == data['name']
                      ? Color(0xFF5DADE2) // สีฟ้าสำหรับหมวดหมู่ที่เลือก
                      : Color(0xFFFAF9F6), // สีขาวครีม
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: currenCategory == data['name']
                        ? Color(0xFFF5B041) // สีเหลืองทองสำหรับขอบที่เลือก
                        : Color(0xFFD5DBDB), // สีเทาอ่อนสำหรับขอบ
                    width: 1.5,
                  ),
                ),
                child: Center(
                  child: Row(
                    children: [
                      if (data['icon'] is IconData)
                        Icon(
                          data['icon'],
                          size: 15.0,
                          color: currenCategory == data['name']
                              ? Colors.white // สีขาวสำหรับไอคอนที่เลือก
                              : Color(
                                  0xFF5DADE2), // สีฟ้าสำหรับไอคอนที่ไม่ได้เลือก
                        )
                      else if (data['icon'] is Image)
                        SizedBox(
                          width: 20.0,
                          height: 20.0,
                          child: data['icon'],
                        ),
                      SizedBox(width: 10.0),
                      Text(
                        data['name'],
                        style: TextStyle(
                          color: currenCategory == data['name']
                              ? Colors.white // สีขาวสำหรับข้อความที่เลือก
                              : Color(
                                  0xFF424949), // สีเทาเข้มสำหรับข้อความที่ไม่ได้เลือก
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
