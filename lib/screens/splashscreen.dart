// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:budget_tracker_application_2/widgets/auth_gate.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // ตั้งเวลาหน่วง 4 วินาทีเพื่อแสดง SplashScreen
    Future.delayed(Duration(seconds: 4), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AuthGate()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor:
          Color(0xFFAEDFF2), // สีพื้นหลัง SplashScreen เป็นสีฟ้าอ่อน
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Lottie Animation
            Lottie.asset(
              'assets/animations/Animation - 1727884603463.json',
              height: size.height * 0.3,
              width: size.width * 0.6,
            ),
            SizedBox(height: 30.0),
            // ชื่อแอป
            Text(
              "PNS",
              style: TextStyle(
                fontSize: 48, // ขนาดของข้อความใหญ่ขึ้นเพื่อความโดดเด่น
                color: Color(
                    0xFFD9D055), // สีเหลืองสดใสให้ตัวหนังสือชื่อแอปโดดเด่น
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    offset: Offset(2.0, 2.0),
                    blurRadius: 4.0,
                    color: Colors.black26, // เงาสีเทาอ่อน
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.0),
            // คำอธิบาย
            Text(
              "Finance Management App",
              style: TextStyle(
                fontSize: 22, // ขนาดของข้อความใหญ่ขึ้นเพื่อความชัดเจน
                color: Color(0xFFBFB960), // สีเหลืองครีมให้คำอธิบายดูนุ่มนวล
                shadows: [
                  Shadow(
                    offset: Offset(1.5, 1.5),
                    blurRadius: 3.0,
                    color: Colors.black12, // เงาสีเทาอ่อน
                  ),
                ],
              ),
            ),
            SizedBox(height: 30.0),
            // Progress Indicator
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                  Color(0xFFC2EDF2)), // สีฟ้ากลางของตัวโหลด
            ),
          ],
        ),
      ),
    );
  }
}
