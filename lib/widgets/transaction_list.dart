// ignore_for_file: prefer_const_constructors

import 'package:budget_tracker_application_2/widgets/transaction_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TransectionList extends StatelessWidget {
  TransectionList({
    super.key,
    required this.category,
    required this.type,
    required this.monthYear,
  });

  final userId = FirebaseAuth.instance.currentUser!.uid;
  final String category;
  final String type;
  final String monthYear;

  @override
  Widget build(BuildContext context) {
    // สร้าง Query ตามค่า category, type และ monthYear
    Query query = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection("transactions")
        .orderBy('timestamp', descending: true)
        .where('monthyear', isEqualTo: monthYear)
        .where('type', isEqualTo: type);

    // ตรวจสอบหมวดหมู่ หากไม่ใช่ 'All' ให้เพิ่มเงื่อนไข filter
    if (category != 'All') {
      query = query.where('category', isEqualTo: category);
    }

    return StreamBuilder<QuerySnapshot>(
      stream: query.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        // จัดการข้อผิดพลาด
        if (snapshot.hasError) {
          return Center(
            child: Text(
              'เกิดข้อผิดพลาด: ${snapshot.error}',
              style: TextStyle(color: Colors.red, fontSize: 18),
            ),
          );
        }

        // แสดง Loading ขณะรอข้อมูล
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              color: Color(0xFFAEDFF2),
            ),
          );
        }

        // หากไม่มีข้อมูล แสดงข้อความแจ้ง
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/icons/checklist.png",
                  height: 100,
                  width: 100,
                ),
                SizedBox(height: 20),
                Text(
                  'ไม่พบรายการธุรกรรม',
                  style: TextStyle(fontSize: 20, color: Color(0xFFAEDFF2)),
                ),
              ],
            ),
          );
        }

        // มีข้อมูล แสดงใน ListView
        var data = snapshot.data!.docs;

        return ListView.separated(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          separatorBuilder: (context, index) => Divider(
            color: Color(0xFFBFB960),
            height: 1,
          ),
          itemCount: data.length,
          itemBuilder: (context, index) {
            var cardData = data[index];
            var transactionId = cardData.id;

            return Container(
              decoration: BoxDecoration(
                color: Color(0xFFC2EDF2),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: TransactionCard(
                data: cardData,
                transactionId: transactionId,
                userId: userId,
              ),
            );
          },
        );
      },
    );
  }
}
