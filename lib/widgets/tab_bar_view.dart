// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'transaction_list.dart';

class TypeTabBar extends StatelessWidget {
  const TypeTabBar({
    super.key,
    required this.category,
    required this.monthYear,
  });

  final String category;
  final String monthYear;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          Container(
            color: Color(0xFF5DADE2), // สีพื้นหลังของ TabBar (ฟ้า)
            child: TabBar(
              indicatorColor:
                  Color(0xFFF5B041), // สีเส้นใต้ของแท็บที่ถูกเลือก (เหลืองทอง)
              labelColor: Colors.white, // สีข้อความของแท็บที่ถูกเลือก (ขาว)
              unselectedLabelColor:
                  Color(0xFFD5DBDB), // สีข้อความของแท็บที่ไม่ได้เลือก (เทาอ่อน)
              indicatorWeight: 3.0, // ความหนาของเส้นใต้แท็บ
              tabs: [
                Tab(
                  text: "รายรับ", // ข้อความแท็บสำหรับเครดิต
                ),
                Tab(
                  text: "รายจ่าย", // ข้อความแท็บสำหรับเดบิต
                ),
              ],
              labelStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold, // ตัวหนาเมื่อแท็บถูกเลือก
              ),
              unselectedLabelStyle: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal, // ตัวปกติเมื่อแท็บไม่ถูกเลือก
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: Color(0xFFFAF9F6), // สีพื้นหลังของ TabBarView (ขาวครีม)
              child: TabBarView(
                children: [
                  TransectionList(
                    category: category,
                    type: 'credit',
                    monthYear: monthYear,
                  ),
                  TransectionList(
                    category: category,
                    type: 'debit',
                    monthYear: monthYear,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
