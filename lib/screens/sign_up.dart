// ignore_for_file: camel_case_types, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:budget_tracker_application_2/screens/login_screen.dart';
import 'package:budget_tracker_application_2/service/auth_service.dart';
import 'package:budget_tracker_application_2/utils/appvalidator.dart';
import 'package:lottie/lottie.dart';

class SingUP_UI extends StatefulWidget {
  SingUP_UI({super.key});

  @override
  State<SingUP_UI> createState() => _SingUP_UIState();
}

class _SingUP_UIState extends State<SingUP_UI> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _userNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final authService = AuthService();
  bool isLoader = false;
  final appValidator = Appvalidator();

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoader = true;
      });

      var data = {
        "username": _userNameController.text,
        "email": _emailController.text,
        "password": _passwordController.text,
        "phone": _phoneController.text,
        'remainingAmount': 0,
        'totalCredit': 0,
        'totalDebit': 0,
      };

      await authService.createUser(data, context);

      setState(() {
        isLoader = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFAFA), // พื้นหลังสีขาวครีม
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: 60.0),
                Lottie.asset(
                  'assets/animations/signup_animation.json',
                  height: 170.0,
                  width: 170.0,
                  fit: BoxFit.cover,
                ),
                SizedBox(height: 16.0),
                Text(
                  "สร้างบัญชีใหม่",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFFD9D055), // สีเหลืองสดใส
                    fontSize: 28.0,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        blurRadius: 10.0,
                        color: Colors.black.withOpacity(0.25),
                        offset: Offset(3, 3),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16.0),

                // ช่องกรอกอีเมล
                TextFormField(
                  controller: _emailController,
                  style: TextStyle(color: Color(0xFF4A4A4A)),
                  keyboardType: TextInputType.emailAddress,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration:
                      _buildInputDecoration("อีเมล", 'assets/icons/email.png'),
                  validator: appValidator.validateEmail,
                ),
                SizedBox(height: 16.0),

                // ช่องกรอกรหัสผ่าน
                TextFormField(
                  controller: _passwordController,
                  style: TextStyle(color: Color(0xFF4A4A4A)),
                  keyboardType: TextInputType.visiblePassword,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  obscureText: true,
                  decoration: _buildInputDecoration(
                      "รหัสผ่าน", 'assets/icons/lock.png'),
                  validator: appValidator.validatePassword,
                ),
                SizedBox(height: 16.0),

                // ช่องกรอกชื่อ
                TextFormField(
                  controller: _userNameController,
                  style: TextStyle(color: Color(0xFF4A4A4A)),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration:
                      _buildInputDecoration("ชื่อ", 'assets/icons/user.png'),
                  validator: appValidator.validateUsername,
                ),
                SizedBox(height: 16.0),

                // ช่องกรอกเบอร์โทรศัพท์
                TextFormField(
                  controller: _phoneController,
                  style: TextStyle(color: Color(0xFF4A4A4A)),
                  keyboardType: TextInputType.phone,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: _buildInputDecoration(
                      "เบอร์โทรศัพท์", 'assets/icons/smartphone.png'),
                  validator: appValidator.validatePhoneNumber,
                ),
                SizedBox(height: 40.0),

                // ปุ่มสมัครสมาชิก
                SizedBox(
                  height: 50.0,
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFAEDFF2), // สีฟ้าอ่อน
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    onPressed: () {
                      isLoader ? print("Loading") : _submitForm();
                    },
                    child: isLoader
                        ? Center(
                            child:
                                CircularProgressIndicator(color: Colors.white))
                        : Text(
                            "สมัครสมาชิก",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                              shadows: [
                                Shadow(
                                  blurRadius: 5.0,
                                  color: Colors.black.withOpacity(0.25),
                                  offset: Offset(2, 2),
                                ),
                              ],
                            ),
                          ),
                  ),
                ),
                SizedBox(height: 20.0),

                // ปุ่มเพื่อไปยังหน้าล็อกอิน
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                  child: Text(
                    "เข้าสู่ระบบ",
                    style: TextStyle(
                      color: Color(0xFFC2EDF2), // สีฟ้ากลาง
                      fontSize: 20.0,
                      shadows: [
                        Shadow(
                          blurRadius: 5.0,
                          color: Colors.black.withOpacity(0.25),
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String label, String iconPath) {
    return InputDecoration(
      fillColor: Color(0xFFFFFAFA),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xFFC2EDF2)), // สีฟ้ากลาง
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xFFD1D99A)), // สีเขียวมะกอก
      ),
      filled: true,
      labelStyle: TextStyle(
        color: Color(0xFF4A4A4A),
        shadows: [
          Shadow(
            blurRadius: 5.0,
            color: Colors.black.withOpacity(0.25),
            offset: Offset(2, 2),
          ),
        ],
      ),
      labelText: label,
      suffixIcon: SizedBox(
        width: 24,
        height: 24,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            iconPath,
            fit: BoxFit.contain,
          ),
        ),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
    );
  }
}
