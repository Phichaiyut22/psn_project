// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables, no_leading_underscores_for_local_identifiers, unused_import

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HeroCard extends StatelessWidget {
  HeroCard({
    super.key,
    required this.userId,
    required this.color,
    required this.textColor,
  });

  final String userId;
  final Color color;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    final Stream<DocumentSnapshot> _usersStream =
        FirebaseFirestore.instance.collection('users').doc(userId).snapshots();

    return StreamBuilder<DocumentSnapshot>(
      stream: _usersStream,
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('เกิดข้อผิดพลาด: ${snapshot.error}'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(color),
              strokeWidth: 5.0,
            ),
          );
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return Center(child: Text("ไม่พบข้อมูลในเอกสารนี้"));
        }

        var data = snapshot.data!.data() as Map<String, dynamic>;

        return AnimatedContainer(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          color: color,
          child: Cards(
            data: data,
            color: color,
            textColor: textColor,
          ),
        );
      },
    );
  }
}

class Cards extends StatelessWidget {
  const Cards({
    super.key,
    required this.data,
    required this.color,
    required this.textColor,
  });

  final Map<String, dynamic> data;
  final Color color;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat('#,##0');

    // แสดงเฉพาะยอดเงินคงเหลือ (remainingAmount)
    String remainingAmount = data['remainingAmount'] != null
        ? formatter.format(data['remainingAmount'])
        : "0";
    String totalCredit = data['totalCredit'] != null
        ? formatter.format(data['totalCredit'])
        : "0";
    String totalDebit =
        data['totalDebit'] != null ? formatter.format(data['totalDebit']) : "0";

    return Container(
      color: color,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // เปลี่ยนข้อความจาก "ยอดเงินคงเหลือ" เป็น "ยอดเงินคงเหลือทั้งหมด"
            buildLabelText("ยอดเงินคงเหลือทั้งหมด", remainingAmount),
            SizedBox(height: 30),
            Container(
              padding:
                  EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color(0xFFFAF9F6), // สีพื้นหลังการ์ดในส่วนล่าง (ขาวครีม)
              ),
              child: Row(
                children: [
                  // เปลี่ยนข้อความจาก "เครดิต" เป็น "รายรับทั้งหมด"
                  buildTransactionCard(
                      'รายรับทั้งหมด', totalCredit, Color(0xFF5DADE2)), // สีฟ้า
                  SizedBox(width: 10),
                  // เปลี่ยนข้อความจาก "เดบิต" เป็น "รายจ่ายทั้งหมด"
                  buildTransactionCard('รายจ่ายทั้งหมด', totalDebit,
                      Color(0xFFF5B041)), // สีเหลืองทอง
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildLabelText(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 18.0,
            color: textColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 5),
        Text(
          "฿ $value",
          style: TextStyle(
            fontSize: 50.0,
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget buildTransactionCard(String heading, String amount, Color color) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    heading,
                    style: TextStyle(color: color, fontSize: 14.0),
                  ),
                  Text(
                    "฿ $amount",
                    style: TextStyle(
                      color: color,
                      fontSize: 23.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: heading == "รายรับทั้งหมด"
                    ? Image.asset(
                        'assets/icons/uparrow.png',
                        width: 24.0,
                        height: 24.0,
                      )
                    : Image.asset(
                        'assets/icons/downarrow.png',
                        width: 24.0,
                        height: 24.0,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
