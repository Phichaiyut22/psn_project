// ignore_for_file: prefer_const_constructors, sort_child_properties_last, unused_import

import 'package:budget_tracker_application_2/screens/about_screen.dart';
import 'package:flutter/material.dart';
import 'package:budget_tracker_application_2/screens/login_screen.dart';
import 'package:budget_tracker_application_2/widgets/add_transaction_form.dart';
import 'package:budget_tracker_application_2/widgets/hero_card.dart';
import 'package:budget_tracker_application_2/widgets/transaction_card.dart';
import 'package:budget_tracker_application_2/screens/edit_profile_screen.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreenUI extends StatefulWidget {
  const HomeScreenUI({super.key});

  @override
  State<HomeScreenUI> createState() => _HomeScreenUIState();
}

class _HomeScreenUIState extends State<HomeScreenUI> {
  var isLogoutLoading = false;
  var isClearLoading = false;
  String? username;

  @override
  void initState() {
    super.initState();
    _fetchUsername();
  }

  Future<void> _fetchUsername() async {
    final userId = getUserId();
    if (userId != null) {
      var userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      if (mounted) {
        setState(() {
          username = userDoc.data()?['username'] ?? 'User';
        });
      }
    }
  }

  Future<void> logOut() async {
    if (mounted) {
      setState(() => isLogoutLoading = true);
    }
    await FirebaseAuth.instance.signOut();
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    }
    if (mounted) {
      setState(() => isLogoutLoading = false);
    }
  }

  String? getUserId() => FirebaseAuth.instance.currentUser?.uid;

  Future<void> clearAllTransactions(String userId) async {
    if (mounted) {
      setState(() => isClearLoading = true);
    }
    try {
      var transactionCollection = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('transactions');

      var snapshots = await transactionCollection.get();
      for (var doc in snapshots.docs) {
        await doc.reference.delete();
      }

      // อัปเดตเฉพาะยอดเงินคงเหลือและรายการที่เกี่ยวข้อง
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'remainingAmount': 0,
        'totalCredit': 0,
        'totalDebit': 0,
      });
    } catch (e) {
      debugPrint("Error clearing transactions: $e");
    }

    if (mounted) {
      setState(() => isClearLoading = false);
    }
  }

  void _showAddTransactionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        contentPadding: EdgeInsets.all(10.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        content: AddTransactionForm(),
      ),
    );
  }

  void _showConfirmationDialog(String userId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('ยืนยันการลบ'),
          content: Text('คุณต้องการเคลียร์รายการทั้งหมดใช่ไหม ?'),
          actions: <Widget>[
            TextButton(
              child: Text('ยกเลิก', style: TextStyle(color: Color(0xFFBFB960))),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('ตกลง', style: TextStyle(color: Color(0xFFD9D055))),
              onPressed: () async {
                Navigator.of(context).pop();
                await clearAllTransactions(userId);
              },
            ),
          ],
        );
      },
    );
  }

  void _showLogoutConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('ยืนยันการออกจากระบบ'),
          content: Text('คุณต้องการออกจากระบบใช่ไหม ?'),
          actions: <Widget>[
            TextButton(
              child: Text('ยกเลิก', style: TextStyle(color: Color(0xFFBFB960))),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('ตกลง', style: TextStyle(color: Color(0xFFD9D055))),
              onPressed: () async {
                Navigator.of(context).pop();
                await logOut();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final userId = getUserId();

    return Scaffold(
      backgroundColor: Color(0xFFAEDFF2), // พื้นหลังหลักของแอป
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFFD9D055), // ปุ่มเพิ่มรายการ
        onPressed: _showAddTransactionDialog,
        child: Image.asset(
          'assets/icons/add.png',
          width: 44.0,
          height: 44.0,
        ),
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
      ),
      appBar: AppBar(
        backgroundColor: Color(0xFFC2EDF2),
        elevation: 2.0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "สวัสดีคุณ ${username ?? 'User'}",
              style: TextStyle(
                color: Color(0xFF424949),
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
            Text(
              "เริ่มจัดการการเงินกันเถอะ :)",
              style: TextStyle(
                color: Color(0xFF424949),
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Image.asset(
              'assets/icons/about.png',
              width: 34.0,
              height: 34.0,
            ),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AboutScreen()),
            ),
          ),
          IconButton(
            onPressed: () {
              if (userId != null) {
                _showConfirmationDialog(userId);
              }
            },
            icon: isClearLoading
                ? SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Image.asset(
                    'assets/icons/rubbish-bin.png',
                    width: 34.0,
                    height: 34.0,
                  ),
          ),
          IconButton(
            onPressed: _showLogoutConfirmationDialog,
            icon: isLogoutLoading
                ? SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Image.asset(
                    'assets/icons/logout.png',
                    width: 34.0,
                    height: 34.0,
                  ),
          ),
        ],
      ),
      body: userId != null
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  HeroCard(
                    userId: userId,
                    color: Color(0xFFD1D99A), // พื้นหลังของการ์ด
                    textColor: Color(0xFF424949), // สีข้อความในการ์ด
                  ),
                  SizedBox(height: 10.0),
                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .doc(userId)
                          .collection('transactions')
                          .orderBy('timestamp', descending: true)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Center(
                              child: Text('เกิดข้อผิดพลาด: ${snapshot.error}'));
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }
                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return Center(
                              child: Text(
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Color.fromARGB(255, 27, 28, 28)),
                                  'ไม่มีรายการธุรกรรม'));
                        }

                        var transactions = snapshot.data!.docs;
                        return ListView.separated(
                          separatorBuilder: (context, index) =>
                              Divider(height: 1, color: Color(0xFFD5DBDB)),
                          itemCount: transactions.length,
                          itemBuilder: (context, index) {
                            var transactionData = transactions[index].data();
                            var transactionId = transactions[index].id;
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: TransactionCard(
                                data: transactionData,
                                transactionId: transactionId,
                                userId: userId,
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            )
          : Center(child: Text('กรุณาล็อกอินเพื่อดูรายการของคุณ')),
    );
  }
}
