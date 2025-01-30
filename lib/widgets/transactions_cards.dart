// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_import

// นำเข้าแพ็กเกจที่จำเป็น
import 'package:budget_tracker_application_2/utils/icons_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'transaction_card.dart'; // สำหรับการ์ดแสดงข้อมูลการทำธุรกรรม

// คลาส TransactionsCard เป็น StatelessWidget ใช้แสดงหัวข้อ "Recent Transactions" และเรียก RecentTransactionsList
class TransactionsCard extends StatelessWidget {
  TransactionsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Padding(
                padding: EdgeInsets.only(right: 8.0),
                child: Image.asset(
                  "assets/icons/transaction.png",
                  width: 24,
                ), // ใช้รูปแทน Icon
              ),
              Text(
                "Recent Transactions", // แสดงหัวข้อ
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFAEDFF2), // ใช้สีฟ้าอ่อนสำหรับหัวข้อ
                ),
              ),
            ],
          ),
          SizedBox(height: 10), // ระยะห่างเล็กน้อยระหว่างหัวข้อและรายการ
          Flexible(
            child:
                RecentTransactionsList(), // Widget สำหรับแสดงรายการธุรกรรมล่าสุด
          ),
        ],
      ),
    );
  }
}

// คลาส RecentTransactionsList เป็น StatelessWidget ใช้แสดงรายการธุรกรรมล่าสุดของผู้ใช้
class RecentTransactionsList extends StatelessWidget {
  RecentTransactionsList({super.key});

  final userId =
      FirebaseAuth.instance.currentUser?.uid; // ตรวจสอบว่าใช้ล็อกอินหรือไม่

  @override
  Widget build(BuildContext context) {
    // ถ้าไม่มีการล็อกอิน
    if (userId == null) {
      return Center(
        child: Text(
          'กรุณาล็อกอินก่อน', // ข้อความเตือนเมื่อผู้ใช้ยังไม่ล็อกอิน
          style: TextStyle(fontSize: 18, color: Colors.red),
        ),
      );
    }

    // ใช้ StreamBuilder เพื่อดึงข้อมูลแบบเรียลไทม์จาก Firestore
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection("transactions")
          .orderBy('timestamp', descending: true)
          .limit(20)
          .snapshots(), // จำกัดการแสดงผลเพียง 20 รายการล่าสุด
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        // แสดงข้อความเมื่อมีข้อผิดพลาด
        if (snapshot.hasError) {
          return Center(
            child: Text(
              'เกิดข้อผิดพลาดบางอย่าง',
              style: TextStyle(fontSize: 18, color: Colors.red),
            ),
          );
        }

        // แสดงตัวบ่งชี้การโหลดเมื่อข้อมูลกำลังโหลด
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child: CircularProgressIndicator(color: Color(0xFFAEDFF2)));
        }

        // แสดงข้อความเมื่อไม่มีข้อมูลธุรกรรม
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Image.asset(
                    "assets/icons/question.png",
                    width: 80,
                  ), // ใช้รูปแทน Icon
                ),
                SizedBox(height: 10),
                Text(
                  'ไม่พบธุรกรรม', // ข้อความแสดงว่าไม่มีธุรกรรม
                  style: TextStyle(
                      fontSize: 18,
                      color: Color(0xFFAEDFF2)), // ใช้สีฟ้าอ่อนสำหรับข้อความ
                ),
              ],
            ),
          );
        }

        // เมื่อมีข้อมูลแสดงรายการธุรกรรม
        var data = snapshot.data!.docs;

        return ListView.builder(
          itemCount: data.length,
          padding: EdgeInsets.symmetric(vertical: 10),
          physics: BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            var cardData = data[index];
            var transactionId =
                cardData.id; // ดึง transactionId สำหรับแต่ละรายการ
            return Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFFC2EDF2), // ใช้พื้นหลังการ์ดเป็นสีฟ้าอ่อน
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3), // เงาของการ์ด
                    ),
                  ],
                ),
                child: TransactionCard(
                  data: cardData, // ส่งข้อมูลธุรกรรมไปยัง TransactionCard
                  transactionId: transactionId, // ส่ง transactionId
                  userId: userId!, // ส่ง userId
                ),
              ),
            );
          },
        );
      },
    );
  }
}
