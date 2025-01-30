// ignore_for_file: prefer_const_constructors

import 'package:budget_tracker_application_2/utils/icons_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CategoryDropdown extends StatelessWidget {
  final String? cattype;
  final ValueChanged<String?> onChanged;
  final AppIcons appIcons = AppIcons();

  CategoryDropdown({
    super.key,
    this.cattype,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final selectedCategory = appIcons.homeExpensesCategories.firstWhere(
      (category) => category['name'] == cattype,
      orElse: () => appIcons.homeExpensesCategories.first,
    );

    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFFAF9F6), // พื้นหลังขาวครีม
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: Color(0xFF5DADE2), // สีฟ้าอ่อนสำหรับขอบ
          width: 1.5,
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: DropdownButton<String>(
        value: cattype ?? selectedCategory['name'] as String,
        isExpanded: true,
        dropdownColor: Color(0xFFFAF9F6), // สีขาวครีมของ dropdown
        icon: Icon(
          Icons.arrow_drop_down,
          color: Color(0xFF5DADE2), // สีฟ้าสำหรับลูกศร dropdown
        ),
        underline: SizedBox(),
        hint: Text(
          "เลือกหมวดหมู่",
          style: TextStyle(color: Color(0xFF424949)), // สีเทาเข้ม
        ),
        items: appIcons.homeExpensesCategories.map((e) {
          return DropdownMenuItem<String>(
            value: e['name'] as String,
            child: Row(
              children: [
                if (e['icon'] is SvgPicture)
                  e['icon'] as SvgPicture
                else if (e['icon'] is Image)
                  e['icon'] as Image,
                SizedBox(width: 10.0),
                Text(
                  e['name_th'] as String,
                  style: TextStyle(
                    color: Color(0xFF424949), // สีเทาเข้ม
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
        onChanged: (newCategory) {
          onChanged(newCategory); // บันทึกหมวดหมู่ใหม่ลงในฐานข้อมูล
        },
      ),
    );
  }
}
