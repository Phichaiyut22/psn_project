// นำเข้าแพ็กเกจที่จำเป็น
import 'package:budget_tracker_application_2/screens/dashboard.dart'; // หน้า Dashboard สำหรับผู้ใช้ที่เข้าสู่ระบบแล้ว
import 'package:budget_tracker_application_2/screens/login_screen.dart'; // หน้า Login สำหรับผู้ใช้ที่ยังไม่ได้เข้าสู่ระบบ
import 'package:firebase_auth/firebase_auth.dart'; // สำหรับจัดการสถานะการเข้าสู่ระบบของ Firebase
import 'package:flutter/material.dart';

// คลาส AuthGate เป็น StatelessWidget เนื่องจากไม่จำเป็นต้องจัดการ State ภายใน
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    // ใช้ StreamBuilder เพื่อตรวจสอบสถานะการเข้าสู่ระบบของผู้ใช้แบบเรียลไทม์
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance
            .authStateChanges(), // ตรวจสอบการเปลี่ยนแปลงสถานะการเข้าสู่ระบบ
        builder: (context, snapshot) {
          // ถ้าไม่มีข้อมูลผู้ใช้ (ยังไม่ได้เข้าสู่ระบบ) แสดงหน้าจอล็อกอิน
          if (!snapshot.hasData) {
            return LoginScreen();
          }

          // ถ้ามีข้อมูลผู้ใช้ (เข้าสู่ระบบแล้ว) แสดงหน้า Dashboard
          return const DashboardUI();
        });
  }
}
