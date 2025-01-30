// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionCard extends StatelessWidget {
  const TransactionCard({
    super.key,
    required this.data,
    required this.transactionId,
    required this.userId,
  });

  final dynamic data;
  final String transactionId;
  final String userId;

  Future<void> _recalculateTotals(String userId) async {
    var transactionCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('transactions');

    var snapshots = await transactionCollection.get();

    double totalCredit = 0;
    double totalDebit = 0;

    for (var doc in snapshots.docs) {
      var data = doc.data();
      double amount = double.tryParse(data['amount'].toString()) ?? 0;
      if (data['type'] == 'credit') {
        totalCredit += amount;
      } else if (data['type'] == 'debit') {
        totalDebit += amount;
      }
    }

    double remainingAmount = totalCredit - totalDebit;

    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      'remainingAmount': remainingAmount,
      'totalCredit': totalCredit,
      'totalDebit': totalDebit,
    });
  }

  Future<void> _deleteTransaction(BuildContext context) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('transactions')
          .doc(transactionId)
          .delete();

      await _recalculateTotals(userId);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('ลบรายการสำเร็จและคำนวณยอดใหม่เรียบร้อยแล้ว')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('เกิดข้อผิดพลาดในการลบ: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    int? timestamp = int.tryParse(data['timestamp'].toString());
    DateTime date = timestamp != null
        ? DateTime.fromMillisecondsSinceEpoch(timestamp)
        : DateTime.now();

    String title = data?['title'] ?? 'ไม่มีชื่อรายการ';
    String amount = data?['amount'] != null
        ? '฿${NumberFormat("#,##0.00", "en_US").format((data['amount'] is int ? data['amount'] : (data['amount'] as num?)?.toDouble()) ?? 0.0)}'
        : 'ไม่มีจำนวนเงิน';

    Color borderColor, textColor, backgroundColor;
    if (data?['type'] == 'credit') {
      borderColor = Color(0xFF5DADE2); // สีฟ้าสำหรับเครดิต
      textColor = Color(0xFF5DADE2);
      backgroundColor = Color(0xFFFAF9F6);
    } else if (data?['type'] == 'debit') {
      borderColor = Color(0xFFF5B041); // สีเหลืองทองสำหรับเดบิต
      textColor = Color(0xFFF5B041);
      backgroundColor = Color(0xFFFAF9F6);
    } else {
      borderColor = Colors.grey.shade400;
      textColor = Colors.grey.shade800;
      backgroundColor = Color(0xFFFAF9F6);
    }

    String iconPath = _getCategoryIconPath(data?['category'] ?? 'others');
    String formattedDate = DateFormat('d MMM yyyy, hh:mm a').format(date);

    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('คุณกดที่ $title')),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: borderColor,
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                offset: Offset(0, 5),
                color: Colors.black.withOpacity(0.05),
                blurRadius: 15,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: borderColor.withOpacity(0.1),
                  child: Image.asset(
                    iconPath,
                    width: 45,
                    height: 45,
                  ),
                ),
                SizedBox(width: 16.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      SizedBox(height: 5.0),
                      Text(
                        amount,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: textColor,
                        ),
                      ),
                      SizedBox(height: 5.0),
                      Text(
                        formattedDate,
                        style: TextStyle(
                          fontSize: 14,
                          color: textColor.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 10.0),
                Icon(
                  data?['type'] == 'credit'
                      ? Icons.arrow_upward
                      : Icons.arrow_downward,
                  color: textColor,
                  size: 24.0,
                ),
                IconButton(
                  icon: Image.asset(
                    'assets/icons/rubbish-bin.png',
                    width: 30.0,
                    height: 30.0,
                  ),
                  onPressed: () {
                    _deleteTransaction(context);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getCategoryIconPath(String category) {
    switch (category) {
      case 'gas':
        return 'assets/icons/gas-station.png';
      case 'grocery':
        return 'assets/icons/grocery.png';
      case 'internet':
        return 'assets/icons/no-wifi.png';
      case 'entertainment':
        return 'assets/icons/movie.png';
      case 'restaurant':
        return 'assets/icons/dining.png';
      default:
        return 'assets/icons/money.png';
    }
  }
}
