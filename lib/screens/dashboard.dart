// ignore_for_file: use_build_context_synchronously, unused_import, prefer_const_constructors

// ส่วนการ import ไฟล์และแพ็กเกจที่จำเป็นสำหรับการทำงานของหน้า DashboardUI
import 'package:budget_tracker_application_2/screens/edit_profile_screen.dart';
import 'package:budget_tracker_application_2/screens/home_screen.dart'; // หน้าหลักของแอปพลิเคชัน
import 'package:budget_tracker_application_2/screens/transaction_screen.dart'; // หน้าสำหรับแสดงประวัติการทำธุรกรรม
import 'package:budget_tracker_application_2/screens/stock_screen.dart'; // หน้าสำหรับแสดงข้อมูลสต็อกสินค้า
import 'package:budget_tracker_application_2/widgets/navbar.dart'; // นำเข้า Widget Navbar เพื่อแสดงแท็บนำทาง
import 'package:flutter/material.dart';

// คลาส DashboardUI เป็น StatefulWidget เพื่อให้สามารถอัพเดต State ของ UI ได้
class DashboardUI extends StatefulWidget {
  const DashboardUI({super.key});

  @override
  State<DashboardUI> createState() => _DashboardUIState();
}

// ส่วนคลาส _DashboardUIState สำหรับจัดการ State ของ DashboardUI
class _DashboardUIState extends State<DashboardUI> {
  // ตัวแปรเพื่อเก็บสถานะการโหลดเมื่อทำการ Logout
  var isLogoutLoading = false;

  // ตัวแปร currentIndex เพื่อระบุหน้าที่กำลังแสดงอยู่ในปัจจุบัน
  int currentIndex = 0;

  // รายการของหน้าต่าง ๆ ที่จะสลับแสดงตามการเลือกใน Navigation Bar
  var pageViewList = [
    HomeScreenUI(), // หน้าหลัก
    TransactionScreenUI(), // หน้าประวัติธุรกรรม
    StockScreenUI(),
    EditProfileScreen()
    // EditProfileScreen(),

    // หน้าสำหรับการแสดงข้อมูลสต็อกสินค้า
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // การแสดง Navbar ที่อยู่ด้านล่างของหน้าจอ
      bottomNavigationBar: Navbar(
        selectedIndex: currentIndex, // หน้าที่ถูกเลือกในปัจจุบัน
        onDestinationSelected: (int value) {
          // ฟังก์ชันเรียกเมื่อเลือกแท็บใหม่ใน Navbar
          setState(() {
            currentIndex = value; // เปลี่ยนค่า currentIndex ตามแท็บที่ถูกเลือก
          });
        },
      ),
      // แสดงหน้า UI ตาม currentIndex จาก pageViewList
      body: pageViewList[currentIndex],
    );
  }
}
