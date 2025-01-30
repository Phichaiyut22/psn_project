// ignore_for_file: use_super_parameters, prefer_const_constructors

import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(" About Us",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Color(0xFFAEDFF2),
        leading: IconButton(
          icon: Image.asset(
            'assets/icons/back_arrow.png',
            // color: Colors.white,
            width: 35,
            height: 35,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // เพิ่มหัวข้อ "DEVELOPER TEAM" พร้อมเงาและสีสัน
          Text(
            "DEVELOPER TEAM",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Color(0xFFD9D055),
              shadows: [
                Shadow(
                  offset: Offset(3.0, 3.0),
                  blurRadius: 5.0,
                  color: Colors.black.withOpacity(0.4),
                ),
                Shadow(
                  offset: Offset(-2.0, -2.0),
                  blurRadius: 5.0,
                  color: Colors.white.withOpacity(0.8),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24.0),
          const DeveloperCard(
            name: 'นายกิตติคุณ ธิใจ',
            role: 'Application Developer',
            studentId: 'S6652D10021',
            imageUrl: 'assets/images/S__71032837.jpg',
          ),
          const SizedBox(height: 16.0),
          const DeveloperCard(
            name: 'นายพิชัยยุทธ เปี่ยมอบ',
            role: 'Application Developer',
            studentId: 'S6652D10022',
            imageUrl: 'assets/images/S__102744079.jpg',
          ),
          const SizedBox(height: 16.0),
          const DeveloperCard(
            name: 'นายธนพล ดัสกร',
            role: 'Application Developer',
            studentId: 'S6652D10025',
            imageUrl: 'assets/images/S__143081477.jpg',
          ),
        ],
      ),
    );
  }
}

class DeveloperCard extends StatelessWidget {
  final String name;
  final String role;
  final String studentId;
  final String imageUrl;

  const DeveloperCard({
    Key? key,
    required this.name,
    required this.role,
    required this.studentId,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      color: const Color(0xFFC2EDF2),
      elevation: 6.0,
      shadowColor: const Color(0xFFBFB960),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Image.asset(
                imageUrl,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16.0),
            Text(
              name,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF333333),
                shadows: [
                  Shadow(
                    offset: Offset(2.0, 2.0),
                    blurRadius: 4.0,
                    color: Colors.black.withOpacity(0.4),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              'รหัสนักศึกษา: $studentId',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF666666),
              ),
            ),
            const SizedBox(height: 4.0),
            Text(
              role,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF555555),
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
