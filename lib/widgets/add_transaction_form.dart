// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:budget_tracker_application_2/utils/appvalidator.dart';
import 'package:budget_tracker_application_2/widgets/category_dropdown.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';

class AddTransactionForm extends StatefulWidget {
  const AddTransactionForm({super.key});

  @override
  State<AddTransactionForm> createState() => _AddTransactionFormState();
}

class _AddTransactionFormState extends State<AddTransactionForm> {
  var type = "credit";
  var category = "MySalary";
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var isLoader = false;
  final appValidator = Appvalidator();
  final amountEditCtrl = TextEditingController();
  final titleEditCtrl = TextEditingController();
  final uid = Uuid();

  String _formatNumber(String s) {
    if (s.isEmpty) return '';
    final formatter = NumberFormat('#,###');
    return formatter.format(int.parse(s.replaceAll(',', '')));
  }

  void _onAmountChanged() {
    String newText = _formatNumber(amountEditCtrl.text);
    amountEditCtrl.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }

  @override
  void initState() {
    super.initState();
    amountEditCtrl.addListener(_onAmountChanged);
  }

  @override
  void dispose() {
    amountEditCtrl.removeListener(_onAmountChanged);
    amountEditCtrl.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoader = true);
      try {
        final user = FirebaseAuth.instance.currentUser;
        int timestamp = DateTime.now().millisecondsSinceEpoch;
        double amount =
            double.tryParse(amountEditCtrl.text.replaceAll(',', '')) ??
                0.0; // แปลงจำนวนเงินเป็น double
        DateTime date = DateTime.now();
        var id = uid.v4();
        String monthyear = DateFormat('MMM y', 'th').format(date);

        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .get();
        final userData = userDoc.data() as Map<String, dynamic>?;

        double remainingAmount = (userData?['remainingAmount'] ?? 0).toDouble();
        double totalCredit = (userData?['totalCredit'] ?? 0).toDouble();
        double totalDebit = (userData?['totalDebit'] ?? 0).toDouble();
        double salaryTotal = (userData?['salaryTotal'] ?? 0).toDouble();

        // คำนวณยอดรวม
        if (type == 'credit') {
          remainingAmount += amount;
          totalCredit += amount;
          if (category == 'MySalary') salaryTotal += amount;
        } else {
          remainingAmount -= amount;
          totalDebit += amount;
        }

        // อัปเดตข้อมูลใน Firestore (บันทึกเป็น int)
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({
          "remainingAmount": remainingAmount.toInt(),
          "totalCredit": totalCredit.toInt(),
          "totalDebit": totalDebit.toInt(),
          "salaryTotal": salaryTotal.toInt(),
          "updatedAt": timestamp,
        });

        var data = {
          "id": id,
          "title": titleEditCtrl.text,
          "amount": amount, // บันทึกจำนวนเงินเป็น double
          "type": type,
          "timestamp": timestamp,
          "totalCredit": totalCredit.toInt(),
          "totalDebit": totalDebit.toInt(),
          "remainingAmount": remainingAmount.toInt(),
          "monthyear": monthyear,
          "category": category,
        };

        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection("transactions")
            .doc(id)
            .set(data);

        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('เกิดข้อผิดพลาด: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
      } finally {
        setState(() => isLoader = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "เพิ่มรายการค่าใช้จ่ายหรือรายรับใหม่",
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Color(0xFF5DADE2), // สีฟ้าสำหรับหัวข้อ
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.0),

            // ฟิลด์ชื่อรายการ
            buildTextField(
              controller: titleEditCtrl,
              label: 'ชื่อรายการ',
              icon: "assets/icons/title.png", // Image asset icon
            ),
            SizedBox(height: 10.0),

            // ฟิลด์จำนวนเงิน
            buildTextField(
              controller: amountEditCtrl,
              label: 'จำนวนเงิน',
              icon: "assets/icons/money-bag.png", // Image asset icon
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
            ),
            SizedBox(height: 10.0),

            // Dropdown สำหรับเลือกหมวดหมู่
            CategoryDropdown(
              cattype: category,
              onChanged: (String? value) {
                if (value != null) setState(() => category = value);
              },
            ),
            SizedBox(height: 10.0),

            // Dropdown สำหรับเลือกประเภทการทำธุรกรรม
            DropdownButtonFormField<String>(
              value: type,
              decoration: InputDecoration(
                labelText: 'ประเภทการทำธุรกรรม',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Color(0xFFFAF9F6), // สีขาวครีม
              ),
              items: [
                DropdownMenuItem(
                  child: Text('รายรับ'),
                  value: 'credit',
                ),
                DropdownMenuItem(
                  child: Text('รายจ่าย'),
                  value: 'debit',
                ),
              ],
              onChanged: (value) {
                if (value != null) setState(() => type = value);
              },
            ),
            SizedBox(height: 20.0),

            // ปุ่มบันทึกข้อมูล
            ElevatedButton.icon(
              onPressed: isLoader ? null : _submitForm,
              icon: isLoader
                  ? CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    )
                  : Image.asset("assets/icons/save.png",
                      width: 24), // Image asset icon
              label: Text(
                isLoader ? '' : "บันทึกรายการ",
                style: TextStyle(fontSize: 18.0),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFF5B041), // สีเหลืองทองของปุ่ม
                padding: EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ฟังก์ชันสร้าง TextFormField สำหรับฟิลด์กรอกข้อมูล
  Widget buildTextField({
    required TextEditingController controller,
    required String label,
    required String icon,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: appValidator.isEmptyCheck,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(icon, width: 24, height: 24), // Image asset icon
        ),
        border: OutlineInputBorder(),
        filled: true,
        fillColor: Color(0xFFFAF9F6), // สีขาวครีมของ TextField
      ),
    );
  }
}
