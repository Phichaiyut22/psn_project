import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:budget_tracker_application_2/widgets/category_list.dart';
import 'package:budget_tracker_application_2/widgets/tab_bar_view.dart';
import 'package:budget_tracker_application_2/widgets/time_line_month.dart';

class TransactionScreenUI extends StatefulWidget {
  const TransactionScreenUI({super.key});

  @override
  _TransactionScreenUIState createState() => _TransactionScreenUIState();
}

class _TransactionScreenUIState extends State<TransactionScreenUI> {
  String category = 'All';
  String monthYear = '';
  DateTime currentDate = DateTime.now(); // เก็บวันที่ปัจจุบัน

  @override
  void initState() {
    super.initState();
    // กำหนดค่าเดือนปัจจุบัน
    monthYear = DateFormat('MMM y', 'th_TH').format(currentDate);
  }

  // ฟังก์ชันอัปเดตเดือน
  void updateMonthYear(DateTime? value) {
    if (value != null) {
      setState(() {
        monthYear = DateFormat('MMM y', 'th_TH')
            .format(value); // แปลง DateTime เป็น String
        print("Updated MonthYear: $monthYear"); // Debug ตรวจสอบค่าเดือน
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFD9D055),
        elevation: 4.0,
        title: Text(
          "ตัวติดตามการใช้จ่าย",
          style: TextStyle(
            fontSize: screenWidth * 0.06,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: Color(0xFFFFFAFA),
      body: Column(
        children: [
          SizedBox(height: screenHeight * 0.02),

          // Timeline Month Selector
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
            child: Container(
              height: screenHeight * 0.08,
              decoration: BoxDecoration(
                color: Color(0xFFC2EDF2),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: TimeLineMonth(
                onChange: (DateTime? value) {
                  updateMonthYear(value); // อัปเดตเดือน
                },
              ),
            ),
          ),
          SizedBox(height: screenHeight * 0.02),

          // Category Selector
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
            child: Container(
              height: screenHeight * 0.08,
              decoration: BoxDecoration(
                color: Color(0xFFD1D99A),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: CategoryList(
                onChange: (String? value) {
                  if (value != null) {
                    setState(() {
                      category = value;
                      print("Updated Category: $category");
                    });
                  }
                },
              ),
            ),
          ),
          SizedBox(height: screenHeight * 0.02),

          // TabBarView Section
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFFAEDFF2),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: TypeTabBar(
                  category: category,
                  monthYear:
                      monthYear, // ส่งค่า monthYear ที่อัปเดตไปยัง TabBarView
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
