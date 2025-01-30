// นำเข้าแพ็กเกจที่จำเป็น
import 'package:budget_tracker_application_2/screens/dashboard.dart'; // หน้า Dashboard ที่ไปหลังจากสมัครหรือล็อกอินสำเร็จ
import 'package:budget_tracker_application_2/service/db.dart'; // สำหรับเรียกใช้ Database Service
import 'package:firebase_auth/firebase_auth.dart'; // ใช้จัดการ Authentication ของ Firebase
import 'package:flutter/material.dart';

// คลาส AuthService สำหรับจัดการการยืนยันตัวตนของผู้ใช้
class AuthService {
  final db = Db(); // สร้างอินสแตนซ์ของ Db สำหรับการเรียกใช้ Database Service
  final FirebaseAuth _auth =
      FirebaseAuth.instance; // สร้างอินสแตนซ์ของ FirebaseAuth

  // ฟังก์ชันสร้างผู้ใช้ใหม่
  Future<void> createUser(
      Map<String, dynamic> data, BuildContext context) async {
    try {
      // สร้างผู้ใช้ใหม่ด้วยอีเมลและรหัสผ่าน
      await _auth.createUserWithEmailAndPassword(
        email: data['email'],
        password: data['password'],
      );
      // บันทึกข้อมูลผู้ใช้ในฐานข้อมูล
      await db.addUser(data, context);
      // นำผู้ใช้ไปยังหน้า Dashboard
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => DashboardUI()),
      );
    } catch (e) {
      // แสดงข้อความข้อผิดพลาดถ้าสมัครสมาชิกไม่สำเร็จ
      _showErrorDialog(context, "Sign up Failed", e.toString());
    }
  }

  // ฟังก์ชันเข้าสู่ระบบ
  Future<bool> login(Map<String, dynamic> data, BuildContext context) async {
    try {
      // เข้าสู่ระบบด้วยอีเมลและรหัสผ่าน
      await _auth.signInWithEmailAndPassword(
        email: data['email'],
        password: data['password'],
      );
      return true; // ล็อกอินสำเร็จ
    } catch (e) {
      // แสดงข้อความข้อผิดพลาดถ้าล็อกอินไม่สำเร็จ
      _showErrorDialog(context, "รหัสผ่านไม่ถูกต้อง",
          "รหัสผ่านที่คุณป้อนไม่ถูกต้อง โปรดลองอีกครั้ง");
      return false; // ล็อกอินไม่สำเร็จ
    }
  }

  // ฟังก์ชันรีเซ็ตรหัสผ่าน
  Future<void> resetPassword(String email, BuildContext context) async {
    try {
      // ส่งลิงก์รีเซ็ตรหัสผ่านไปยังอีเมลของผู้ใช้
      await _auth.sendPasswordResetEmail(email: email);
      // แสดงข้อความ SnackBar เพื่อแจ้งให้ผู้ใช้ทราบว่าลิงก์รีเซ็ตรหัสผ่านถูกส่งไปแล้ว
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Password reset link sent to $email")),
      );
    } catch (e) {
      // แสดงข้อความข้อผิดพลาดถ้าส่งลิงก์รีเซ็ตรหัสผ่านไม่สำเร็จ
      _showErrorDialog(context, "Reset Password Error", e.toString());
    }
  }

  // ฟังก์ชันสำหรับแสดงข้อผิดพลาดในรูปแบบ AlertDialog
  void _showErrorDialog(BuildContext context, String title, String message) {
    if (context.mounted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(title), // หัวข้อของ AlertDialog
          content: Text(message), // เนื้อหาของ AlertDialog
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(), // ปิด AlertDialog
              child: Text("ตกลง"),
            ),
          ],
        ),
      );
    }
  }
}
