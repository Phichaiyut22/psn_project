// นำเข้าแพ็กเกจที่จำเป็น
import 'package:cloud_firestore/cloud_firestore.dart'; // สำหรับเชื่อมต่อกับ Firestore
import 'package:firebase_auth/firebase_auth.dart'; // สำหรับจัดการ Authentication ของ Firebase
import 'package:flutter/material.dart';

// คลาส Db สำหรับจัดการการทำงานกับ Firestore
class Db {
  // สร้างตัวแปร users อ้างอิงไปยัง Collection 'users' ใน Firestore
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  // ฟังก์ชัน addUser สำหรับเพิ่มข้อมูลผู้ใช้ใหม่ใน Firestore
  Future<void> addUser(data, context) async {
    // ดึง userId ของผู้ใช้ที่ล็อกอินอยู่ปัจจุบัน
    final userId = FirebaseAuth.instance.currentUser!.uid;
    // เพิ่มข้อมูลผู้ใช้ใน Firestore โดยใช้ userId เป็น document ID
    await users
        .doc(userId)
        .set(data) // ตั้งค่าข้อมูลจาก data ที่ได้รับ
        .then(
            (value) => print("User Added")) // แสดงข้อความเมื่อเพิ่มข้อมูลสำเร็จ
        .catchError((error) {
      // จัดการข้อผิดพลาดกรณีที่เพิ่มข้อมูลไม่สำเร็จ
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Login Error"), // หัวข้อของ AlertDialog
            content: Text(error.toString()), // แสดงข้อความข้อผิดพลาด
          );
        },
      );
    });
  }
}
