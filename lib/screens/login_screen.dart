// ignore_for_file: prefer_const_constructors

import 'package:budget_tracker_application_2/screens/dashboard.dart';
import 'package:budget_tracker_application_2/screens/sign_up.dart';
import 'package:budget_tracker_application_2/screens/Forgot_Password_Screen.dart';
import 'package:budget_tracker_application_2/service/auth_service.dart';
import 'package:budget_tracker_application_2/utils/appvalidator.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:budget_tracker_application_2/styles.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  var isLoader = false;
  var authService = AuthService();
  var appValidator = Appvalidator();

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoader = true;
      });

      var data = {
        "email": _emailController.text,
        "password": _passwordController.text,
      };

      bool loginSuccess = await authService.login(data, context);

      setState(() {
        isLoader = false;
      });

      if (loginSuccess) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => DashboardUI()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Color(0xFFFFFAFA), // พื้นหลังสีครีม
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.04),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: screenHeight * 0.1),
                Lottie.asset(
                  'assets/animations/Animation - 1727884603463.json',
                  height: screenHeight * 0.15,
                  width: screenWidth * 0.3,
                  fit: BoxFit.cover,
                ),
                SizedBox(height: screenHeight * 0.02),
                SizedBox(
                  width: screenWidth * 0.7,
                  child: Text(
                    "เข้าสู่ระบบ",
                    textAlign: TextAlign.center,
                    style: customTextStyle(
                      fontSize: screenWidth * 0.07,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFD9D055), // สีเหลืองสดใส
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                TextFormField(
                  controller: _emailController,
                  style: customTextStyle(color: Color(0xFF4A4A4A)),
                  decoration:
                      _buildInputDecoration("อีเมล", 'assets/icons/email.png'),
                  validator: appValidator.validateEmail,
                ),
                SizedBox(height: screenHeight * 0.02),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  style: customTextStyle(color: Color(0xFF4A4A4A)),
                  decoration: _buildInputDecoration(
                      "รหัสผ่าน", 'assets/icons/lock.png'),
                  validator: appValidator.validatePassword,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ForgotPasswordScreen(),
                        ),
                      );
                    },
                    child: Text(
                      "ลืมรหัสผ่านใช่ไหม?",
                      style: customTextStyle(
                        color: Color(0xFFBFB960), // สีเหลืองครีม
                        fontSize: screenWidth * 0.04,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.03),
                SizedBox(
                  height: screenHeight * 0.06,
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFAEDFF2), // สีฟ้าอ่อน
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    onPressed: isLoader ? null : _submitForm,
                    child: isLoader
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text(
                            "เข้าสู่ระบบ",
                            style: customTextStyle(color: Colors.white),
                          ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.015),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => SingUP_UI()),
                    );
                  },
                  child: Text(
                    "สร้างบัญชีใหม่",
                    style: customTextStyle(
                      color: Color(0xFFC2EDF2), // สีฟ้ากลาง
                      fontSize: screenWidth * 0.05,
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
        borderSide: BorderSide(
          color: Color(0xFFC2EDF2), // สีฟ้ากลาง
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xFFAEDFF2)), // สีฟ้าอ่อนเมื่อโฟกัส
      ),
      filled: true,
      labelStyle: customTextStyle(color: Color(0xFF4A4A4A)),
      labelText: label,
      suffixIcon: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Image.asset(
          iconPath,
          width: 24,
          height: 24,
        ),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
    );
  }
}
